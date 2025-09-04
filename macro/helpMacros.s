
// _set8im - store an 8bit constant to a memory location
.macro _set8im(value, dst)
{
	lda #value
	sta dst
}

// _copy8 - copy an 8bit value from memory location to a memory location
.macro _copy8(src, dst)
{
	lda src
	sta dst
}

// _add8im - add a 8bit constant to a memory location, store in result
.macro _add8im(src, value, dst)
{
	clc
	lda src
	adc #value
	sta dst
}

// _add8 - add a 8bit value to a memory location, store in result
.macro _add8(src, value, dst)
{
	clc
	lda src
	adc value
	sta dst
}

// _sub8im - sub a 8bit constant to a memory location, store in result
.macro _sub8im(src, value, dst)
{
	sec
	lda src
	sbc #value
	sta dst
}

// _sub8 - sub a 8bit value to a memory location, store in result
.macro _sub8(src, value, dst)
{
	sec
	lda src
	sbc value
	sta dst
}

// _set16 - copy a 16bit memory location to dest memory location
.macro _set16(src, dst)
{
	lda src+0
	sta dst+0
	lda src+1
	sta dst+1
}

// _set16ofs - copy a 16bit memory location to dest memory location and add offset
.macro _set16ofs(src, ofs, dst)
{
	clc
	lda src+0
	adc #<ofs
	sta dst+0
	lda src+1
	adc #>ofs
	sta dst+1
}

// _set16im - store a 16bit constant to a memory location
.macro _set16im(value, dst)
{
	lda #<value
	sta dst+0
	lda #>value
	sta dst+1
}

//Double the number
.macro _double16(srcdst)
{
	asl srcdst+0
	rol srcdst+1
}

// _add16im - add a 16bit constant to a memory location, store in result
.macro _add16im(src, value, dst)
{
	clc						// ensure carry is clear
	lda src+0				// add the two least significant bytes
	adc #<value
	sta dst+0
	lda src+1				// add the two most significant bytes
	adc #>value
	sta dst+1
}

// _add16 - add a 16bit value to a memory location, store in result
.macro _add16(src, value, dst)
{
	clc						// ensure carry is clear
	lda src+0				// add the two least significant bytes
	adc value
	sta dst+0
	lda src+1				// add the two most significant bytes
	adc value+1
	sta dst+1
}

// _sub16im - sub a 16bit constant to a memory location, store in result
.macro _sub16im(src, value, dst)
{
	sec						// SET CARRY 
	lda src+0 				// LOW HALF OF 16-BIT NUMBER IN $C0 AND $C1 
	sbc #<value				// LOW HALF OF 16-BIT NUMBER IN $B0 AND $B1 
	sta dst+0
	lda src+1 				// HIGH HALF OF 16-BIT NUMBER IN $C0 AND $C1 
	sbc #>value 			// HIGH HALF OF 16-BIT NUMBER IN $B0 AND $B1 
	sta dst+1 
}

// _sub16 - sub a 16bit value to a memory location, store in result
.macro _sub16(src, value, dst)
{
	sec						// SET CARRY 
	lda src+0 				// LOW HALF OF 16-BIT NUMBER IN $C0 AND $C1 
	sbc value				// LOW HALF OF 16-BIT NUMBER IN $B0 AND $B1 
	sta dst+0
	lda src+1 				// HIGH HALF OF 16-BIT NUMBER IN $C0 AND $C1 
	sbc value+1 			// HIGH HALF OF 16-BIT NUMBER IN $B0 AND $B1 
	sta dst+1 
}

// _and16im - and a 16bit constant with a memory location, store in result
.macro _and16im(src, value, dst)
{
	lda src+0
	and #<value
	sta dst+0
	lda src+1
	and #>value
	sta dst+1
}

// _and16 - and a 16bit value with a memory location, store in result
.macro _and16(src, value, dst)
{
	lda src+0
	and value+0
	sta dst+0
	lda src+1
	and value+1
	sta dst+1
}

.macro _swap16(ptr1, ptr2)
{
	lda ptr1
	pha
	lda ptr1+1
	pha
	_set16(ptr2,ptr1)
	pla
	sta ptr2+1
	pla
	sta ptr2
}

// _set24im - store a 24bit constant to a memory location
.macro _set24im(value, dst)
{
	lda #<value
	sta dst+0
	lda #>value
	sta dst+1
	lda #[value >> 16]
	sta dst+2
}

// _set24 - store a 24bit value to a memory location
.macro _set24(value, dst)
{
	lda value+0
	sta dst+0
	lda value+1
	sta dst+1
	lda value+2
	sta dst+2
}

// _add24im - add a 24bit constant to a memory location, store in result
.macro _add24im(src, value, dst)
{
	clc
	lda src+0
	adc #<value
	sta dst+0
	lda src+1
	adc #>value
	sta dst+1
	lda src+2
	adc #[value >> 16]
	sta dst+2
}

// _add24 - add a 24bit value to a memory location, store in result
.macro _add24(src, value, dst)
{
	clc
	lda src+0
	adc value
	sta dst+0
	lda src+1
	adc value+1
	sta dst+1
	lda src+2
	adc value+2
	sta dst+2
}

// _sub24im - sub a 24bit constant to a memory location, store in result
.macro _sub24im(src, value, dst)
{
	sec 
	lda src+0 
	sbc #<value 
	sta dst+0
	lda src+1 
	sbc #>value 
	sta dst+1 
	lda src+2 
	sbc #[value >> 16] 
	sta dst+2
}

// _sub24 - sub a 24bit value to a memory location, store in result
.macro _sub24(src, value, dst)
{
	sec
	lda src+0
	sbc value
	sta dst+0
	lda src+1
	sbc value+1
	sta dst+1 
	lda src+2
	sbc value+2
	sta dst+2
}

.macro _half24(srcdst)
{
	lda srcdst+2
	cmp #$80
	ror
	ror srcdst+1
	ror srcdst+0
	sta srcdst+2
}

// _set32im - store a 32bit constant to a memory location
.macro _set32im(value, dst)
{
	lda #<value
	sta dst+0
	lda #>value
	sta dst+1
	lda #[value >> 16]
	sta dst+2
	lda #[value >> 24]
	sta dst+3
}

// _set32 - store a 32bit value to a memory location
.macro _set32(value, dst)
{
	lda value+0
	sta dst+0
	lda value+1
	sta dst+1
	lda value+2
	sta dst+2
	lda value+3
	sta dst+3
}

// _add32im - add a 32bit constant to a memory location, store in result
.macro _add32im(src, value, dst)
{
	clc
	lda src+0
	adc #<value
	sta dst+0
	lda src+1
	adc #>value
	sta dst+1
	lda src+2
	adc #[value >> 16]
	sta dst+2
	lda src+3
	adc #[value >> 24]
	sta dst+3
}

// _sub32im - sub a 32bit constant to a memory location, store in result
.macro _sub32im(src, value, dst)
{
	sec 
	lda src+0 
	sbc #<value 
	sta dst+0
	lda src+1 
	sbc #>value 
	sta dst+1 
	lda src+2 
	sbc #[value >> 16] 
	sta dst+2
	lda src+3 
	sbc #[value >> 24] 
	sta dst+3 
}


//convert a negative number to its absolute value
.macro absolute_value(num){
        lda num                 // Carica il numero
        bpl already_positive    // Salta se già positivo
        eor #$ff                // Inverti tutti i bit
        clc                     // Cancella il Carry
        adc #$01                // Aggiungi 1
        sta num                 // Salva il valore positivo

already_positive:
                                // Fine del programma
}

//convert a negative number to its absolute value
//The new ptr is stored in X register
.macro ptr_for_array_word(Contatore){
    lda Contatore      // Carica il contatore (1-6) nel registro A
    sec                // Imposta il Carry per la sottrazione
    sbc #1             // Converti il contatore in 0-5 (0-indexed)
    asl               // Moltiplica per 2 (ogni elemento è largo 2 byte)
    tax                // Trasferisci il risultato nel registro X
}
