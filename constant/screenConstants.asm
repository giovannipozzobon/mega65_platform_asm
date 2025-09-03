#importonce

// ----------------------------------- SCREEN CONSTANTS -----------------------------------
.const COLOR_OFFSET = $0800		// Offset ColorRam to make bank $10000 contiguous
.const COLOR_RAM = $ff80000 + COLOR_OFFSET
.const CHARS_RAM = $10000		// all bg chars / pixie data goes here
.const MAP_RAM = $40000			// bg map data goes here

.const SCREEN_RAM = $50000		// screen ram / pixie work ram goes here
.const SCREENMEM = $50000 // this is screen ram
.const GRAPHMEM  = $40000        // this is character ram (or graphic in this case)
.const COLORRAM  = $ff81000      // this is in high ram $ff 8 1000

// ------------------------------------------------------------
// Defines to describe the screen size
//
// If you use H320 then SCREEN_WIDTH much be <= 360, otherwise <= 720
#define H320
.const SCREEN_WIDTH = 320

// If you use V200 then SCREEN_HEIGHT much be <= 240, otherwise <= 480
#define V200
.const SCREEN_HEIGHT = 200

// Figure out how many characters wide and high the visible area is
//
.const CHARS_WIDE = (SCREEN_WIDTH / 8)
.const NUM_ROWS = (SCREEN_HEIGHT / 8)
.const NR_BYTE_ROW = CHARS_WIDE * 2
.print "NR_BYTE_ROW: " + toIntString(NR_BYTE_ROW)  
.const NR_BYTE_SCREEN = CHARS_WIDE * NUM_ROWS * 2 // 2 bytes for every char
.print "NR_BYTE_SCREEN: " + toIntString(NR_BYTE_SCREEN)  


// We should have a screen size that is larger than the visible area so we can freely
// scroll around it.
//
.const NUM_SCREENS_WIDE = 1
.const NUM_SCREENS_HIGH = 1

// LOGICAL_ROW_SIZE is the number of bytes the VIC-IV advances each row
//
.const LOGICAL_ROW_SIZE = CHARS_WIDE * NUM_SCREENS_WIDE
.const LOGICAL_NUM_ROWS = NUM_ROWS * NUM_SCREENS_HIGH