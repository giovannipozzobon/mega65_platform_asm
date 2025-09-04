//
// ------------------------------------------------------------
//
.macro BasicUpstart65(addr) {
	.segment Code "Main Code"
	*=BASIC65UPSTART "BASIC Upstart"

	.print "Address Main Code = " + toHexString(addr)
	.var addrStr = toIntString(addr)

	.byte $09,$20 //End of command marker (first byte after the 00 terminator)
	.byte $0a,$00 //10
	.byte $fe,$02,$30,$00 //BANK 0
	.byte <end, >end //End of command marker (first byte after the 00 terminator)
	.byte $14,$00 //20
	.byte $9e //SYS
	.text addrStr
	.byte $00
end:
	.byte $00,$00	//End of basic terminators
}

.macro mapHi(source, target, blocks) {
	.var sourceMB = (source & $ff00000) >> 20
	.var sourceOffset = ((source & $00fff00) - target)
	.var sourceOffHi = sourceOffset >> 16
	.var sourceOffLo = (sourceOffset & $0ff00 ) >> 8
	.var bitHi = blocks << 4

	ldy #sourceOffLo
	ldz #[sourceOffHi + bitHi]
}

.macro mapLo(source, target, blocks) {
	.var sourceMB = (source & $ff00000) >> 20
	.var sourceOffset = ((source & $00fff00) - target)
	.var sourceOffHi = sourceOffset >> 16
	.var sourceOffLo = (sourceOffset & $0ff00 ) >> 8
	.var bitLo = blocks << 4

	lda #sourceOffLo
	ldx #[sourceOffHi + bitLo]
}

.macro unmapMemory()
{
	lda #$00
	tax
	tay
	taz
	map
	eom
}


.macro enable40Mhz() {
	lda #$41
	sta $00 	//40 Mhz mode
}

.macro enableVIC4Registers () {
	lda #$00
	tax 
	tay 
	taz 
	map
	eom

	lda #$47	//Enable VIC IV
	sta $d02f
	lda #$53
	sta $d02f
}

.macro disableCIAInterrupts() {
	//Disable CIA interrupts
	lda #$7f
	sta $dc0d
	sta $dd0d
}

.macro disableC65ROM() {
	//Disable C65 rom protection using
	//hypervisor trap (see mega65 manual)	
	lda #$70
	sta $d640
	eom
	//Unmap C65 Roms $d030 by clearing bits 3-7
	lda #%11111000
	trb $d030
}

.macro VIC4_SetScreenPtr(addr) {
	lda #[[addr] & $ff]
	sta $d060
	lda #[[addr >> 8] & $ff]
	sta $d061
	lda #[[addr >> 16] & $ff]
	sta $d062
	lda #[[addr >> 24] & $ff]
	sta $d063
}

.macro VIC4_SetCharPtr(addr) {
	lda #[addr & $ff]
	sta $d068
	lda #[[addr & $ff00]>>8]
	sta $d069
	lda #[[addr & $ff0000]>>16]
	sta $d06a
}

.macro VIC4_SetRowWidth(rowWidth) {
	lda #<rowWidth
	sta $d058
	lda #>rowWidth
	sta $d059
}

.macro VIC4_SetNumCharacters(numChrs) {
	lda #<numChrs
	sta $d05e
	lda $d063
	and #$cf
	ora #((>numChrs) & $03) << 4
	sta $d063
}

.macro VIC4_SetNumRows(numRows) {
	lda #numRows
	sta $d07b 
}

.macro RunDMAJob(JobPointer) {
		lda #[JobPointer >> 16]
		sta $d702
		sta $d704
		lda #>JobPointer
		sta $d701
		lda #<JobPointer
		sta $d705
}
.macro DMAHeader(SourceBank, DestBank) {
		.byte $0A // Request format is F018A
		.byte $80, SourceBank
		.byte $81, DestBank
}
.macro DMAStep(SourceStep, SourceStepFractional, DestStep, DestStepFractional) {
		.byte $82, SourceStepFractional
		.byte $83, SourceStep
		.byte $84, DestStepFractional
		.byte $85, DestStep		
}
.macro DMADisableTransparency() {
		.byte $06
}
.macro DMAEnableTransparency(TransparentByte) {
		.byte $07 
		.byte $86, TransparentByte
}
.macro DMACopyJob(Source, Destination, Length, Chain, Backwards) {
	.byte $00 //No more options
	.if(Chain) {
		.byte $04 //Copy and chain
	} else {
		.byte $00 //Copy and last request
	}	
	
	.var backByte = 0
	.if(Backwards) {
		.eval backByte = $40
		.eval Source = Source + Length - 1
		.eval Destination = Destination + Length - 1
	}
	.word Length //Size of Copy

	//byte 04
	.word Source & $ffff
	.byte [Source >> 16] + backByte

	//byte 07
	.word Destination & $ffff
	.byte [[Destination >> 16] & $0f]  + backByte
	.if(Chain) {
		.word $0000
	}
}


.macro DMAFillJob(SourceByte, Destination, Length, Chain) {
	.byte $00 //No more options
	.if(Chain) {
		.byte $07 //Fill and chain
	} else {
		.byte $03 //Fill and last request
	}	
	
	.word Length //Size of Copy
	//byte 4
	.word SourceByte
	.byte $00
	//byte 7
	.word Destination & $ffff
	.byte [[Destination >> 16] & $0f] 
	.if(Chain) {
		.word $0000
	}
}


.macro DMAMixJob(Source, Destination, Length, Chain, Backwards) {
	.byte $00 //No more options
	.if(Chain) {
		.byte $04 //Mix and chain
	} else {
		.byte $00 //Mix and last request
	}	
	
	.var backByte = 0
	.if(Backwards) {
		.eval backByte = $40
		.eval Source = Source + Length - 1
		.eval Destination = Destination + Length - 1
	}
	.word Length //Size of Copy
	.word Source & $ffff
	.byte [Source >> 16] + backByte
	.word Destination & $ffff
	.byte [[Destination >> 16] & $0f]  + backByte
	.if(Chain) {
		.word $0000
	}
}

