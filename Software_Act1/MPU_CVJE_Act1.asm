;code starts here.
	org 0000h
	
	;PA->Out, PB<-In, PC-F->Out
	
	ld a,82h
	out (CW1),a
	ld a,80h
        out (CW2),a

	;init stackpointer
        ld sp,F800h

	;init digitcouter
	ld b,00h


	ld hl,text1
	call WR_text
	call RD_KB


;subroutines

RD_KB:
	in a,(KB)
	cp 0Dh
	jp z, no_Digit

	cp ' '
	jp z,no_count

	cp 'A'
	jp c,invalido

	cp 'Z'+1
	jp c,valido

	cp 'a'
	jp c,invalido

	cp 'z'+1
	jp c,valido

	jp invalido

valido:
	inc b
	jp RD_KB

no_count:
	jp RD_KB

invalido:
	ld hl,text2
	call WR_text
	jp RD_KB

no_Digit:
	ld hl,text3
	call WR_text
	ld a,b
	call WR_digit
	jp fin_programa

WR_text:
        ld a,(hl)
        cp '&'
        jp z,fin_texto

        out (LCD),a

        inc hl
        jp WR_text

fin_texto:
        ret

;--------
WR_digit:
	ld c,00h

decenas:
	cp 10
	jp c,unidades

	sub 10
	inc c
	jp decenas

unidades:
	ld d,a
	ld a,c
	cp 00h
	jp z,mostrar_unidad
	add a,'0'
	out (LCD),a

mostrar_unidad:
	d a,d
	add a,'0'
	out (LCD),a
	ret

fin_programa:
	jp fin_programa


;data segment
	.org D801h
	text1:	.db "Ingresa tu nombre y apellidos: &"
	text2:	.db " ERROR: Solo letras y espacios &"
	text3:	.db " Cantidad de letras: &"



;constants
	LCD:    .equ 40h
	KB:	.equ 41h
	CW1:	.equ 43h
	CW2:	.equ 47h