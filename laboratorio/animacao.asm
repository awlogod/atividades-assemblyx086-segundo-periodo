TITLE PGM16_2A PUBLIC SET_DISPLAY_MODE, DISPLAY_BALL

.MODEL SMALL
.STACK 100H
.DATA
;==============================
; MACROS
;==============================

DRAW_ROW MACRO X
    LOCAL L1
    ; draws a line in row X from column 10 to column 300
    MOV AH,0CH         ; draw pixel
    MOV AL,1           ; cyan
    MOV CX,10          ; column 10
    MOV DX,X           ; row X
L1:
    INT 10H
    INC CX             ; next column
    CMP CX,301         ; beyond column 300?
    JL L1              ; no, repeat
ENDM

DRAW_COLUMN MACRO Y
    LOCAL L2
    ; draws a line in column Y from row 10 to row 189
    MOV AH,0CH         ; draw pixel
    MOV AL,1           ; cyan
    MOV CX,Y           ; column Y
    MOV DX,10          ; row 10
L2:
    INT 10H
    INC DX             ; next row
    CMP DX,190         ; beyond row 189?
    JL L2              ; no, repeat
ENDM
;==============================
; CODE
;==============================

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    CALL SET_DISPLAY_MODE

    MOV AL,4      ; cor da bola
    MOV CX,50     ; posição inicial coluna
    MOV DX,50     ; posição inicial linha

mover1:
    CALL DISPLAY_BALL     ; desenha a bola

    CALL DELAY            ; espera um pouco

    ; apagar a bola (desenha de novo com cor de fundo)
    MOV AL,1              ; cor do fundo (verde)
    CALL DISPLAY_BALL

    ; mover posição
    INC CX                ; vai pra direita
    INC DX                ; vai pra baixo

    CMP CX,290            ; limite da borda direita
    JG sair1
    CMP DX,180            ; limite da borda inferior
    JG sair1

    MOV AL,4              ; volta pra cor da bola
    JMP mover1
    sair1:

    MOV AL,4      ; cor da bola
    MOV CX,180    ; posição inicial coluna
    MOV DX,50     ; posição inicial linha

mover2:
    CALL DISPLAY_BALL     ; desenha a bola

    CALL DELAY            ; espera um pouco

    ; apagar a bola (desenha de novo com cor de fundo)
    MOV AL,1              ; cor do fundo (verde)
    CALL DISPLAY_BALL

    ; mover posição
    DEC CX                ; vai pra direita
    INC DX                ; vai pra baixo

    CMP CX,50           ; limite da borda direita
    JL sair2
    CMP DX, 180           ; limite da borda inferior
    JG sair2

    MOV AL,4              ; volta pra cor da bola
    JMP mover2
    sair2:
    MOV AH,4CH
    INT 21H
MAIN ENDP

DELAY PROC
    PUSH CX
    PUSH DX
    MOV CX,0FFFFH
    
    delay1:
    LOOP delay1
    
    POP DX
    POP CX
    RET
DELAY ENDP

SET_DISPLAY_MODE PROC
    ; sets display mode and draws boundary
    MOV AH,0           ; set mode
    MOV AL,04H         ; mode 4, 320 x 200, 4 color
    INT 10H

    MOV AH,0BH         ; select palette
    MOV BH,0
    MOV BL,1           ; palette 1
    INT 10H

    MOV BH,0           ; set background color
    MOV BL,1           ; green
    INT 10H

draw_boundary:
    DRAW_ROW 10
    DRAW_ROW 189
    DRAW_COLUMN 10
    DRAW_COLUMN 300
    RET
SET_DISPLAY_MODE ENDP

;==============================
; DISPLAY BALL
;==============================

DISPLAY_BALL PROC
    ; displays ball at column CX and row DX with color given in AL
    ; input: AL = color of ball
    ;         CX = column
    ;         DX = row

    MOV AH,0CH         ; write pixel
    MOV BH,0
    INT 10H

    INC CX             ; pixel on next column
    MOV BH,0
    INT 10H

    INC DX             ; down 1 row
    MOV BH,0
    INT 10H

    DEC CX             ; previous column
    MOV BH,0
    INT 10H

    DEC DX             ; restore DX
    RET
DISPLAY_BALL ENDP

END MAIN
