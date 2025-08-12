.cpu _45gs02


main:

	// Setup the system Mega65
    jsr SYSTEM.setup

    jsr SYSTEM.initialization2


    // Setup the system
    VIC4_SetRowWidth(NR_BYTE_ROW) 

    VIC4_SetNumCharacters(CHARS_WIDE)

    VIC4_SetNumRows(CHARS_HIGH) 


    VIC4_SetScreenPtr(Screen)

    VIC4_SetCharPtr(Chars)

    // return to basic
    jsr SYSTEM.returnToBasic

    rts
/*
gameloop:

        jmp gameloop
        */