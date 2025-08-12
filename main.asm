
.cpu _45gs02

// Import memoryMap
#import "./system/memoryMap.s"

// Import Costants 
#import "./include/constants.asm"

// Import macro
#import "./include/macros.asm"

// BASIC Boilerplate
Basic65Upstart()


// *=GAME_CODE "Game Code"
#import "./src/gameCode.asm"


// *=LIBRARIES_ADDRESS "Libraries"
#import "./include/libraries.asm"



//
// ************* Binary Space **************
// Screen Chars Sprite
//

.align 64
Chars:
        .import binary "./sdcard/TestAseprite10_chr.bin"
        //.import binary "./sdcard/Chars_gfx.bin"
        .print "Chars_end-Chars = " + toIntString(Chars_end-Chars)  
Chars_end:


.align 64
Screen:
        .import binary "./sdcard/job1_LV0L0_map.bin"
        //.import binary "./sdcard/Screen_gfx.bin"
        .print "Screen_end-Screen = " + toIntString(Screen_end-Screen)  
Screen_end:

// ************* The Base Space **************
thebase:
	.byte 0
        .print "thebase: " + toHexString(thebase)

