
.cpu _45gs02


// Import System 
#import "./system/memoryMap.s"
#import "./system/config.s"

// Import Costants 
#import "./include/constants.asm"

// Import macro
#import "./include/macros.asm"

// BASIC Boilerplate
Basic65Upstart()

//VIC4_StoreState(thebase)

// *=GAME_CODE "Game Code"
#import "./src/gameCode.asm"


// *=LIBRARIES_ADDRESS "Libraries"
#import "./include/libraries.asm"

loop:
        jmp loop

//
// ************* Binary Space **************
// Screen Chars Sprite
//

.align 64
Chars:
        //.import binary "./sdcard/font_chr.bin" 
        //.import binary "./sdcard/TestAseprite11_chr.bin"
        //.import binary "./sdcard/Chars_gfx.bin"
        #import "./constant/testchar.asm"
        .print "Chars = " + toHexString(Chars) 
        .print "Chars_end-Chars = " + toIntString(Chars_end-Chars)  
Chars_end:

.align 64
Screen:
        .import binary "./sdcard/job1_LV0L0_map.bin"
        //.import binary "./sdcard/Screen_gfx.bin"
        .print "Screen = " + toHexString(Screen) 
        .print "Screen_end-Screen = " + toIntString(Screen_end-Screen)  
Screen_end:

.align 64
Tiles:
        .import binary "./sdcard/TestAseprite11_tiles.bin"
        .print "Tiles = " + toHexString(Tiles) 
        .print "Tiles_end-Tiles = " + toIntString(Tiles_end-Tiles)  
Tiles_end:
Pal:
        .import binary "./sdcard/font_pal.bin"
        //.import binary "./sdcard/TestAseprite11_pal.bin"
        .print "Tiles = " + toHexString(Tiles) 
        .print "Tiles_end-Tiles = " + toIntString(Pal_end-Pal)  
Pal_end:


// ************* The Base Space **************
thebase:
	.byte 0
        .print "thebase: " + toHexString(thebase)

