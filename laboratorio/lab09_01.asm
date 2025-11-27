.TITLE Inverte um vetor de 7 posições
.MODEL SMALL
.STACK 100h

.DATA
    msgTitulo   DB 13,10,'INVERTER VETOR',13,10,'$'
    msgLer      DB 13,10,'Digite 7 digitos, tecle ENTER apos cada um:',13,10,'$'
    msgInv      DB 13,10,'Vetor invertido:',13,10,'$'
    msgSep      DB ' ', '$'
    msgFim      DB 13,10,'[FIM]',13,10,'$'

    VETOR       DB 7 DUP(?)

.CODE

; Rotina de saída string $-terminada
; Entrada: DX -> string
PrintStr PROC
    MOV AH,09h
    INT 21h
    RET
PrintStr ENDP


; Lê um dígito '0'..'9' do teclado, retorna em AL o valor (0..9)
; e ecoa com nova linha
ReadDigit PROC
    ; esperar tecla
    MOV AH,01h
    INT 21h           ; AL = ASCII
    ; ecoar
    MOV DL,AL
    MOV AH,02h
    INT 21h
    ; nova linha
    MOV DL,13
    MOV AH,02h
    INT 21h
    MOV DL,10
    MOV AH,02h
    INT 21h

    ; converter ASCII -> valor
    SUB AL,'0'
    RET
ReadDigit ENDP

; Procedimento: LerVetor
; Usa BX como base e avança índice
; Preenche VETOR[0..6]
LerVetor PROC
    LEA BX, VETOR       ; BX aponta pro início
    MOV CX,7            ; 7 elementos
LerLoop:
    CALL ReadDigit      ; valor em AL (0..9)
    MOV [BX],AL
    INC BX
    LOOP LerLoop
    RET
LerVetor ENDP

; Procedimento: InverterVetor (in-place, sem vetor auxiliar)
; Usa SI como início, DI como fim, troca até SI>=DI
InverterVetor PROC
    XOR SI,SI           ; SI = 0 (índice inicial)
    MOV DI,6            ; DI = 6 (índice final)
InvLoop:
    CMP SI,DI
    JGE InvDone

    ; pegar base do vetor em BX e trocar VETOR[SI] <-> VETOR[DI]
    LEA BX,VETOR
    MOV AL,[BX+SI]
    XCHG AL,[BX+DI]
    MOV [BX+SI],AL

    INC SI
    DEC DI
    JMP InvLoop
InvDone:
    RET
InverterVetor ENDP

; Procedimento: ImprimirVetor
; Usa BX base, SI índice
ImprimirVetor PROC
    LEA BX,VETOR
    XOR SI,SI
    MOV CX,7
PrnLoop:
    MOV AL,[BX+SI]
    ADD AL,'0'          ; para ASCII
    MOV DL,AL
    MOV AH,02h
    INT 21h
    ; espaço
    LEA DX,msgSep
    CALL PrintStr

    INC SI
    LOOP PrnLoop
    RET
ImprimirVetor ENDP


MAIN PROC
    MOV AX,@DATA
    MOV DS,AX

    LEA DX,msgTitulo
    CALL PrintStr
    LEA DX,msgLer
    CALL PrintStr

    CALL LerVetor
    CALL InverterVetor

    LEA DX,msgInv
    CALL PrintStr
    CALL ImprimirVetor

    LEA DX,msgFim
    CALL PrintStr

    ; sair
    MOV AH,4Ch
    XOR AL,AL
    INT 21h
MAIN ENDP

END MAIN
