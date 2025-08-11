#importonce

.cpu _45gs02

.macro job_copydata(source, dest, len) {
        lda #0                  // call DMA controller to fill screen & charram
        sta DMA_ADDRBANK
        lda #>!fcm_dma+
        sta DMA_ADDRMSB
        lda #<!fcm_dma+
        sta DMA_ADDRLSB_ETRIG   // trigger extended DMA job
        bra !fcm_dma_end+       // branch over DMA job data

!fcm_dma:
        //copy character ram
        .byte $0b, $00   // 11 mode and copy                 
        .byte $00  // copy
        .word len //len
        .word [source & $ffff]
        .byte [(source>>16) & $f]
        .word [dest & $ffff]          // dest
        .byte [(dest>>16) & $f]       // destbnk(0-3) + flags
        .word $0000                     // modulo (ignored)
!fcm_dma_end:
}


.macro job_filldata(dest, value, len) {

        lda #0                  // call DMA controller to fill screen & charram
        sta DMA_ADDRBANK
        lda #>!fcm_dma+
        sta DMA_ADDRMSB
        lda #<!fcm_dma+
        sta DMA_ADDRLSB_ETRIG   // trigger extended DMA job
        bra !fcm_dma_end+       // branch over DMA job data

!fcm_dma:
        //fill dest with value step by 2 bytes
        .byte $0a                       // 11 byte mode
        .byte $85, $02                  // increment by 2
        .byte $00                       // eol
        .byte DMA_FILL                  // fill, chain next job
        .word len
        .word value                     // colour code to fill with, one byte
        .byte $00                       // src bank (ignored)
        .word [dest & $ffff]            // dest
        .byte [(dest>>16) & $f]         // destbnk(0-3) + flags
        .word $0000                     // modulo (ignored)
!fcm_dma_end:
}


.macro inc_Y__Screen(bpbase) {
    .var screenOffs = bpbase+4
    
    //load the actual screen pointer
    lda VICIV_SCRNPTR2
    sta screenOffs+1
    lda VICIV_SCRNPTR1
    sta screenOffs


    clc
    adc #80 // A has already screenOffs
    sta VICIV_SCRNPTR1
    lda screenOffs+1
    adc #0
    sta VICIV_SCRNPTR2

}

.macro dec_Y__Screen(bpbase) {
    .var screenOffs = bpbase+4
    
    //load the actual screen pointer
    lda VICIV_SCRNPTR2
    sta screenOffs+1
    lda VICIV_SCRNPTR1
    sta screenOffs


    clc
    sbc #80-1 // A has already screenOffs
    sta VICIV_SCRNPTR1
    bcs notnegative 
    dec screenOffs+1
notnegative:
    lda screenOffs+1
    sta VICIV_SCRNPTR2

}

.macro SetupSprites(sprite_pointer, sprite_data) {

        // set location of 16 bit sprite pointers 
        lda #<sprite_pointer
        sta $d06c

        lda #>sprite_pointer
        sta $d06d

        // enable location of 16 bit sprite pointers bank 
        lda #$80
        sta $d06e

        // set data for 1st sprite
        lda #<[sprite_data>>6]
        sta sprite_pointer

        lda #>[sprite_data>>6]
        sta sprite_pointer+1

        // set data for 2nd sprite
        lda #<[(sprite_data+(24*8))>>6]
        sta sprite_pointer+2
        .print "Sprite2Ptr: " + toHexString(sprite_data+(24*8))

        lda #>[(sprite_data+(24*8))>>6]
        sta sprite_pointer+3


        // full colour sprite mode for sprites (SPR16EN)
        lda #$03
        sta $d06b

        // 16 pixel wide for all sprites (SPRX64EN) 53335
        lda #$03
        sta $d057

        // 16 pixel high sprite heights
        //lda #16
        // 21 pixel high sprite heights
        lda #21
        sta $d056

        // all sprites use height in $d056 sprhgten
        lda #$ff
        sta $d055

        lda #$08 // sprite multicolor 1
        sta $D025
        lda #$06 // sprite multicolor 2
        sta $D026


        // show the sprite 0 at x=110  y=110
        lda Sprite_Pos_X
        sta $D000
        lda Sprite_Pos_Y
        sta $D001

        // show the sprite 1 at x=80  y=80
        lda #90
        sta $D002
        sta $D003

        //enable first & second sprites
        lda #$03
        sta $d015

        //enable background
        //lda #$ff
        //sta $d01b

        // color sprite 0
        //lda #$06 //BLU
        lda #$00 //Black
        sta $D027

        // color sprite 1
        lda #$00 //Black
        sta $D028



}



.macro debug_msg (msg) {
        ldx #0                          // text index
!txtloop:
        lda msg,x
        beq !endloop+                   // zero terminated text
        sta $D643
        clv
        inx
        bra !txtloop-
!endloop:
        debug_print()
}

.macro debug_char (char) {

        lda #char
	sta $D643
        debug_print()
}

.macro debug_print () {

	clv
        lda #$0d
	sta $D643
	clv
	lda #$0a
        sta $D643
	clv
	ldz #0
}

.macro read_joystick_ports (joy1, joy2){

        // Disable interrupts
        sei

        // Lock out the keyboard lines
        lda #$ff
        sta $dc00

        // Read joystick port 1 state
        lda $dc01
        and #%00011111
        sta joy1

        // Read joystick port 2 state
        lda $dc00
        and #%00011111
        sta joy2
}


.macro test_joy_bitmask (val, mask, comp) {
        lda val
        and #mask
        cmp #comp
}


.macro wait_raster (line) {
.const vicii_rcl = $d012
.const vicii_rch = $d011  // bit 7
.print "wait_raster: " + toHexString(raster)
 raster:
        lda #line
!:
        cmp vicii_rcl
        bne !-
        bit vicii_rch
        bmi !-  // rch is high, not our stop
}


.macro wait_briefly(bpbase, cycle){
.const todtenths = $dc08
.var last_todtenths = bpbase+5

        ldx #cycle
loop:
        lda todtenths
        sta last_todtenths // Wait two ticks to pause between 1/10th
!:      lda todtenths
        cmp last_todtenths
        beq !-
        dex
        bne loop
}



// per PAL 50 volte per secondo per NTCS 60 volte al secondo
// Wait for bit 8 of the raster count to flip negative then positive,
// for a delay between 1 and 2 frames.
.macro wait_very_briefly(cycle) {
        ldx #cycle
loop:
!:      bit $d011
        bpl !-
!:      bit $d011
        bmi !-
        dex
        bne loop
}


//convert a negative number to its absolute value
.macro absolute_value(num){
        lda num                 // Carica il numero
        bpl already_positive    // Salta se già positivo
        eor #$ff                // Inverti tutti i bit
        clc                     // Cancella il Carry
        adc #$01                // Aggiungi 1
        sta num                 // Salva il valore positivo

already_positive:
                                // Fine del programma
}

//convert a negative number to its absolute value
//The new ptr is stored in X register
.macro ptr_for_array_word(Contatore){
    lda Contatore      // Carica il contatore (1-6) nel registro A
    sec                // Imposta il Carry per la sottrazione
    sbc #1             // Converti il contatore in 0-5 (0-indexed)
    asl               // Moltiplica per 2 (ogni elemento è largo 2 byte)
    tax                // Trasferisci il risultato nel registro X
}