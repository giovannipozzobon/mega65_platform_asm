.cpu _45gs02
.segment Code "Entry"

Entry:

	// Setup the system Mega65
    jsr SYSTEM.setup

/*
    lda #DEFAULT_SCREEN_BORDER_COLOR
    sta VICIV_BORDERCOL
    sta VICIV_SCREENCOL             // black background and border


    //corretto
    FCM_InitScreenMemory(0, SCREENMEM, GRAPHMEM, 0, COLORRAM, 11)

    //corretto
    FCM_ScreenOn(SCREENMEM, COLORRAM)
    
    //Copy Char
    .print "char - Chars = " + toIntString(Chars_end-Chars)  
    copydata(Chars, GRAPHMEM, Chars_end-Chars)

    //Copy Screen 1
    copydata(Screen, SCREENMEM, Screen_end-Screen)

    //Fill the High byte of screen 1 to $10 ($1000 that is GRAPHMEM/64) step 2 byte
    filldata(SCREENMEM+1, $10, Screen_end-Screen)
*/

    jsr SYSTEM.initialization2


    lda #(VICIII_SM_H640|VICIII_SM_V400)
    trb VICIII_SCRNMODE                   // clear H640 and V400 for 320x200
    lda VICIV_SCRNMODE
    ora #(VICIV_SM_FCLRHI|VICIV_SM_CHR16) // set FCLRHI + CHR16 
    and #(~VIVIV_SM_FCLRLO)               // clear FCLRLO for super extended attr mode
    sta VICIV_SCRNMODE


    // Setup the system
    VIC4_SetRowWidth(NR_BYTE_ROW) 

    VIC4_SetNumCharacters(CHARS_WIDE)

    VIC4_SetNumRows(NUM_ROWS) 

	// Initialize palette and bgmap data
	jsr InitPalette
	jsr InitBGMap

    //Copy Screen 
    copydata(MapTileRAM, SCREEN_RAM, MapTileRAM_end-MapTileRAM)

    //Copy Attrib 1
    copydata(MapAttribRAM, COLOR_RAM, MapAttribRAM_end-MapAttribRAM)

    VIC4_SetCharPtr(Chars)

    VIC4_SetScreenPtr(SCREEN_RAM)


gameloop:

        jmp gameloop
        

    // return to basic
    //jsr SYSTEM.returnToBasic
