#importonce

.cpu _45gs02

.macro copydata(source, dest, len) {
        lda #0                  // call DMA controller to fill screen & charram
        sta DMA_ADDRBANK
        lda #>!cp_dma+
        sta DMA_ADDRMSB
        lda #<!cp_dma+
        sta DMA_ADDRLSB_ETRIG   // trigger extended DMA job
        bra !cp_dma_end+       // branch over DMA job data

!cp_dma:
        //copy character ram
        .byte $0b, $00   // 11 mode and copy                 
        .byte $00  // copy
        .word len //len
        .word [source & $ffff]
        .byte [(source>>16) & $f]
        .word [dest & $ffff]          // dest
        .byte [(dest>>16) & $f]       // destbnk(0-3) + flags
        .word $0000                     // modulo (ignored)
!cp_dma_end:
}


.macro filldata(dest, value, len) {

        lda #0                  // call DMA controller to fill screen & charram
        sta DMA_ADDRBANK
        lda #>!fill_dma+
        sta DMA_ADDRMSB
        lda #<!fill_dma+
        sta DMA_ADDRLSB_ETRIG   // trigger extended DMA job
        bra !fill_dma_end+       // branch over DMA job data

!fill_dma:
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
!fill_dma_end:
}

