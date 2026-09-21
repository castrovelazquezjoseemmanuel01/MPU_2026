;Castro Velázquez José Emmanuel
;Contador de letras de un nombre propio



;Constantes

LCD     EQU 40H
KB      EQU 41H
CW1     EQU 43H
CW2     EQU 47H

; inicio de codigo

        ORG 0000H

; PA -> Out ; PB -> In  ;  PC-F -> Out

        LD A,82H
        OUT (CW1),A
        LD A,80H
        OUT (CW2),A

; Stack Pointer
        LD SP,F800H


; Contador de letras
        LD B,00H
        LD HL,text1
        CALL WR_txt
        CALL RD_KB



; SUBRUTINES

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

invalido:
        LD HL,text2
        CALL WR_txt
        JP RD_KB

no_count:              ;retorno a RD_KB
        JP RD_KB


no_Digit:
        LD HL,text3
        CALL WR_txt
        LD A,B
        CALL WR_digit
        JP fin_programa


WR_txt:
        LD A,(HL)

        CP '&'
        JP Z,fin_texto

        OUT (LCD),A

        INC HL
        JP WR_txt


fin_texto:
        RET




WR_digit:               ;despliegue en decimal
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


fin_programa:
        JP fin_programa



;Datos

        ORG D801H
text1:	DB "Ingresa tu nombre y apellidos: &"
text2: 	DB " ERROR: Solo letras y espacios &"
text3:	DB " Cantidad de letras: &"

