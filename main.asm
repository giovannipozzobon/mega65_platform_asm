.file [name="main.prg", segments="Code,Data"]

.segmentdef Zeropage [start=$02, min=$02, max=$fb, virtual]
.segmentdef Code [start=$2001, max=$cfff]
.segmentdef Data [start=$4000, max=$cfff]
//.segmentdef BSS [startAfter="Data", max=$cfff, virtual]

.cpu _45gs02

#import "./system/zeropage.s"


// Import System 
#import "./system/memoryMap.s"
#import "./system/config.s"


// Import Costants 
#import "./include/constants.asm"

// Import macro
#import "./include/macros.asm"

// BASIC Boilerplate
//Basic65Upstart()

//.segment Code
BasicUpstart65(Entry)
* = $2016

// *=GAME_CODE "Game Code"
#import "./src/gameCode.asm"


// *=LIBRARIES_ADDRESS "Libraries"
#import "./include/libraries.asm"



.segment Data "Graphics Data"
//
// ************* Binary Space **************
// Screen Chars Sprite
//

.align 64
Chars:
        //.import binary "./sdcard/font_chr.bin" 
        .import binary "./sdcard/TestAseprite10_chr.bin"
        //.import binary "./sdcard/Chars_gfx3.bin"
        //#import "./constant/testchar.asm"
        .print "Chars = " + toHexString(Chars) 
        .print "Chars_end-Chars = " + toIntString(Chars_end-Chars)  
Chars_end:

.align 64
Map:
        .import binary "./sdcard/job1_LV0L0_map.bin"
        //.import binary "./sdcard/Screen_gfx3.bin"
        .print "Map = " + toHexString(Map) 
        .print "Map_end-Map = " + toIntString(Map_end-Map)  
Map_end:

.align 64
Tiles:
        //.import binary "./sdcard/TestAseprite10_tiles.bin"
        .print "Tiles = " + toHexString(Tiles) 
        .print "Tiles_end-Tiles = " + toIntString(Tiles_end-Tiles)  
Tiles_end:
Palette:
        //.import binary "./sdcard/font_pal.bin"
        .import binary "./sdcard/TestAseprite10_pal.bin"
        .print "Palette = " + toHexString(Tiles) 
        .print "Palette_end-Palette = " + toIntString(Palette_end-Palette)  
Palette_end:

.align 64
MapTileRAM:
	.fill (NR_BYTE_ROW*NUM_ROWS), $00
        .print "MapTileRAM = " + toHexString(MapTileRAM) 
MapTileRAM_end:

.align 64
MapAttribRAM:
	.fill (NR_BYTE_ROW*NUM_ROWS), $00
        .print "MapAttribRAM = " + toHexString(MapAttribRAM) 
MapAttribRAM_end:

// ************* The Base Space **************
thebase:
	.byte 0
        .print "thebase: " + toHexString(thebase)

