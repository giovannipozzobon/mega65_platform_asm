
.cpu _45gs02

// Import memoryMap
#import "./system/memoryMap.s"

// Import Costants 
#import "./include/constants.asm"

// Import macro
#import "./include/macros.asm"


Basic65Upstart() // BASIC Boilerplate


// *=GAME_CODE "Game Code"
#import "./src/gameCode.asm"


// *=LIBRARIES_ADDRESS "Libraries"
#import "./include/libraries.asm"


// ************* The Base Space **************
thebase:
	.byte 0
        .print "thebase: " + toHexString(thebase)

