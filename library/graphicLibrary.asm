
// ------------------------------------------------------------
//
InitBGMap:
{
	.var chr_ptr = Tmp					// 32bit
	.var attrib_ptr = Tmp1				// 32bit
	.var line_stride = Tmp2				// 16bit

	.var tiles_ptr = Tmp2+2				// 16bit
	.var map_base = Tmp3				// 16bit
	.var map_offs = Tmp3+2				// 16bit
	.var map_ptr = Tmp4					// 16bit
	.var chr_offs = Tmp4+2				// 16bit
	.var palIndx = Tmp5					// 8bit
	.var line_delta = Tmp5+2			// 16bit
	.var tile_map = Tmp6				// 16bit
    .var num_lines = Tmp6+2             // 8bit

	_set16im(NR_BYTE_ROW, line_delta)        // number of bytes per row
	_set16(line_delta, line_stride)		
    _double16(line_stride)                  // we fill the buffer 2 lines at a time due to tile size of 16x16
	_set16im(Tiles, tile_map)
	_set16im((Chars/64), chr_offs)
    _set16im(Map, map_base)
    _set8im(NUM_ROWS/2, num_lines)        // we process 2 lines at a time due to tile size of 16x16
    _set32im(MapTileRAM, chr_ptr)		// map is decompressed to these locations
    _set32im(MapAttribRAM, attrib_ptr)

	_set8im((Palette<<4) | $0f, palIndx)

    jsr InitMap
    
    rts

InitMap:

    lda line_delta+0
    sta baseAddLo
    lda line_delta+1
    sta baseAddHi

    sec
    lda line_delta+0
    sbc #$02
    sta offsWrapLo
    lda line_delta+1
    sbc #$00
    sta offsWrapHi

    lda line_delta+0
    lsr
    sta colCount

    // y = line (0 - 5)
    ldy #0

_row_loop:

    tya
    pha

    // reset the map offset
	_set16im(0, map_offs)

    ldx #0
    ldz #0

_line_loop: 

    // map_ptr = map_base + map_offs
    _add16(map_base, map_offs, map_ptr)

    // calculate the tile ptr (map_ptr) * 4
    //
    ldy #0
    lda (map_ptr),y             // Get the tile #
    sta tiles_ptr
    iny
    lda (map_ptr),y
    sta tiles_ptr+1

    asl tiles_ptr				// tiles are 4 bytes
    rol tiles_ptr+1
    asl tiles_ptr
    rol tiles_ptr+1

    _add16(tiles_ptr, tile_map, tiles_ptr)

    ldy #0

    // two rows per tile
	lda #$08
	sta ((attrib_ptr)),z
    clc
    lda (tiles_ptr),y
    adc chr_offs+0
    sta ((chr_ptr)),z			// + 0
    iny
    inz
    lda (tiles_ptr),y
    adc chr_offs+1
    sta ((chr_ptr)),z			// + 1
	lda palIndx
	sta ((attrib_ptr)),z
    iny
    dez

    _add16(chr_ptr, line_delta, chr_ptr)
    _add16(attrib_ptr, line_delta, attrib_ptr)

	lda #$08
	sta ((attrib_ptr)),z
    clc
    lda (tiles_ptr),y
    adc chr_offs+0
    sta ((chr_ptr)),z			// line_delta + 0
    iny
    inz
    lda (tiles_ptr),y
    adc chr_offs+1
    sta ((chr_ptr)),z			// line_delta + 1
	lda palIndx
	sta ((attrib_ptr)),z
    iny

    // indexes 0 and 1 have been filled, advance to 2
    inz

    _sub16(chr_ptr, line_delta, chr_ptr)
    _sub16(attrib_ptr, line_delta, attrib_ptr)

    _add16im(map_offs, 2, map_offs)
    lda map_offs+0
    and offsWrapLo:#<[$0f]
    sta map_offs+0
    lda map_offs+1
    and offsWrapHi:#>[$0f]
    sta map_offs+1

    inx
    cpx colCount:#$20
    lbne _line_loop

    // move map_base down a row
    clc
    lda map_base+0
    adc baseAddLo:#<[2*16]
    sta map_base+0
    lda map_base+1
    adc baseAddHi:#>[2*16]
    sta map_base+1

    // move down 2 rows
    _add16(chr_ptr, line_stride, chr_ptr)
    _add16(attrib_ptr, line_stride, attrib_ptr)

    pla
    tay

    iny
    cpy num_lines
    lbne _row_loop

    rts
}


InitPalette: {
		lda $d070
		and #%00111111
		ora #%00000000
		sta $d070 

		ldx #$00
	!:
		lda Palette + $000,x 	// background
		sta $d100,x
		lda Palette + $010,x 
		sta $d200,x
		lda Palette + $020,x 
		sta $d300,x

		inx 
		cpx #$10
		bne !-

		// Ensure index 0 is black
		lda #$00
		sta $d100
		sta $d200
		sta $d300

		lda $d070
		and #%00111111
		ora #%01000000
		sta $d070 

		ldx #$00
	!:
		lda Palette + $020,x 	// background
		sta $d100,x
		lda Palette + $000,x 
		sta $d200,x
		lda Palette + $000,x 
		sta $d300,x

		inx 
		cpx #$10
		bne !-

		// Ensure index 0 is black
		lda #$00
		sta $d100
		sta $d200
		sta $d300

		lda $d070
		and #%11001100
		ora #%00000001
		sta $d070 

		rts
}