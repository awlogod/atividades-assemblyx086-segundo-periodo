title Matriz Soma N x N
.model small
.stack 100h

; ------------ DEFINA O TAMANHO DA MATRIZ AQUI ------------
N EQU 3        ; matriz N x N

.data
msgLer1  db 0Dh,0Ah,'Digite a primeira matriz:',0Dh,0Ah,'$'
msgLer2  db 0Dh,0Ah,'Digite a segunda matriz:',0Dh,0Ah,'$'
msgRes   db 0Dh,0Ah,'Matriz soma:',0Dh,0Ah,'$'

mat1 db N*N dup(?)     ; primeira matriz
mat2 db N*N dup(?)     ; segunda matriz
matSoma db N*N dup(?)  ; matriz resultado

.code

; ==========================================================
; Procedimento: PrintStr
; Imprime string terminada em '$'
; Entrada: DX = endereço da string
; ==========================================================
PrintStr PROC
    push ax
    push si

    mov si, dx
PS_Loop:
    mov al, [si]
    cmp al, '$'
    je PS_End
    mov dl, al
    mov ah,02h
    int 21h
    inc si
    jmp PS_Loop

PS_End:
    pop si
    pop ax
    ret
PrintStr ENDP


; ==========================================================
; Procedimento: LerMatriz
; Lê N*N números do teclado e armazena no vetor apontado por BX
; Entrada: BX = endereço base da matriz
; ==========================================================
LerMatriz PROC
    push ax
    push cx
    push si

    mov si, 0
    mov cx, N*N

LM_Loop:
    mov ah,01h
    int 21h
    sub al,'0'       ; converte ASCII → número
    mov [bx+si], al
    inc si
    loop LM_Loop

    pop si
    pop cx
    pop ax
    ret
LerMatriz ENDP


; ==========================================================
; Procedimento: SomarMatrizes
; Soma cada elemento de MAT1 e MAT2 colocando em MAT_SOMA
; ==========================================================
SomarMatrizes PROC
    push ax
    push cx
    push si

    mov si, 0
    mov cx, N*N

SM_Loop:
    mov al, [mat1+si]
    add al, [mat2+si]
    mov [matSoma+si], al
    inc si
    loop SM_Loop

    pop si
    pop cx
    pop ax
    ret
SomarMatrizes ENDP


; ==========================================================
; Procedimento: ImprimirMatriz
; Imprime matriz na tela com formatação
; ==========================================================
ImprimirMatriz PROC
    push ax
    push cx
    push si

    mov si, 0
    mov cx, N       ; contador de linhas

Linha:
    mov di, N       ; contador de colunas
Coluna:
    mov al, [matSoma+si]
    add al,'0'
    mov dl, al
    mov ah,02h
    int 21h

    mov dl,' '
    mov ah,02h
    int 21h

    inc si
    dec di
    jnz Coluna

    mov dl,0Dh
    mov ah,02h
    int 21h
    mov dl,0Ah
    int 21h

    loop Linha

    pop si
    pop cx
    pop ax
    ret
ImprimirMatriz ENDP


; ================================ MAIN ================================
main PROC
    mov ax,@data
    mov ds,ax

    mov dx, offset msgLer1
    call PrintStr
    mov bx, offset mat1
    call LerMatriz

    mov dx, offset msgLer2
    call PrintStr
    mov bx, offset mat2
    call LerMatriz

    call SomarMatrizes

    mov dx, offset msgRes
    call PrintStr
    call ImprimirMatriz

    mov ah,4Ch
    int 21h
main ENDP

end main
