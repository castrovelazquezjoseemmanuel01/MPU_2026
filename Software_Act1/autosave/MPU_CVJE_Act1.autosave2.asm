;========================================
; PROGRAMA PRINCIPAL
;========================================

        ORG 0000H

        ; PA -> Out
        ; PB -> In
        ; PC -> Out

        LD A,82H
        OUT (CW1),A

        LD A,80H
        OUT (CW2),A

        ; Inicializar Stack Pointer
        LD SP,F800H

        ; Inicializar contador de letras
        LD B,00H

        LD HL,text1
        CALL WR_text

        CALL RD_KB


;========================================
; LECTURA DEL TECLADO
;========================================

RD_KB:
        IN A,(KB)

        CP 0DH
        JP Z,no_Digit

        CP ' '
        JP Z,no_count

        CP 'A'
        JP C,invalido

        CP 'Z'+1
        JP C,valido

        CP 'a'
        JP C,invalido

        CP 'z'+1
        JP C,valido

        JP invalido


valido:
        INC B
        JP RD_KB


no_count:
        JP RD_KB


invalido:
        LD HL,text2
        CALL WR_text
        JP RD_KB


no_Digit:
        LD HL,text3
        CALL WR_text

        LD A,B
        CALL WR_digit

        JP fin_programa


;========================================
; ESCRIBIR TEXTO EN LCD
;========================================

WR_text:
        LD A,(HL)

        CP '&'
        JP Z,fin_texto

        OUT (LCD),A

        INC HL
        JP WR_text


fin_texto:
        RET


;========================================
; ESCRIBIR NUMERO DECIMAL
;========================================

WR_digit:
        LD C,00H


decenas:
        CP 10
        JP C,unidades

        SUB 10
        INC C

        JP decenas


unidades:
        LD D,A

        LD A,C
        CP 00H
        JP Z,mostrar_unidad

        ADD A,'0'
        OUT (LCD),A


mostrar_unidad:
        LD A,D
        ADD A,'0'
        OUT (LCD),A

        RET


;========================================
; FIN DEL PROGRAMA
;========================================

fin_programa:
        JP fin_programa


;========================================
; DATOS
;========================================

        ORG D801H

text1:
        DB "Ingresa tu nombre y apellidos: &"

text2:
        DB " ERROR: Solo letras y espacios &"

text3:
        DB " Cantidad de letras: &"


;========================================
; CONSTANTES
;========================================

LCD     EQU 40H
KB      EQU 41H
CW1     EQU 43H
CW2     EQU 47H