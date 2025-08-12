
.macro debug_msg (msg) {
        ldx #0                          // text index
!txtloop:
        lda msg,x
        beq !endloop+                   // zero terminated text
        sta $D643
        clv
        inx
        bra !txtloop-
!endloop:
        debug_print()
}

.macro debug_char (char) {

        lda #char
	sta $D643
        debug_print()
}

.macro debug_print () {

	clv
        lda #$0d
	sta $D643
	clv
	lda #$0a
        sta $D643
	clv
	ldz #0
}
