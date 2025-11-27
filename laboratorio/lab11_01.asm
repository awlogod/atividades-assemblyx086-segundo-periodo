title Troca Acima / Abaixo da Diagonal
.model small
.stack 100h

; ======== DEFINICAO DO TAMANHO DA MATRIZ ========
N EQU 4       ; Matriz NxN (altere aqui se necessário)

.data
msgLer   db 0Dh,0Ah, 'Digite os valores da matriz (0-9), linha a linha:', 0Dh,0Ah, '$'
msgRes   db 0Dh,0Ah, 'Matriz apos a troca:', 0Dh,0Ah, '$'

matriz db N*N dup(?)     ; matriz linearizada

.code

; ===================== PROCEDIMENTO: PrintStr =====================
; Imprime string terminada por '$'
PrintStr PROC
    push ax
    push si

    mov si, dx         ; SI recebe o endereço da string

PrintStr_Loop:
    mov al, [si]       ; lê caractere
    cmp al, '$'
    je PrintStr_End    ; fim da string

    mov dl, al
    mov ah, 02h
    int 21h

    inc si
    jmp PrintStr_Loop

PrintStr_End:
    pop si
    pop ax
    ret
PrintStr ENDP


; ===================== PROCEDIMENTO: LerMatriz =====================
; Lê N*N números do teclado (0–9) e armazena na matriz
LerMatriz PROC
    push ax
    push bx
    push cx

    mov dx, offset msgLer
    call PrintStr

    mov bx, offset matriz
    mov cx, N*N

LerLoop:
    mov ah,01h
    int 21h
    sub al,'0'
    mov [bx], al
    inc bx
    loop LerLoop

    pop cx
    pop bx
    pop ax
    ret
LerMatriz ENDP


; ===================== PROCEDIMENTO: TrocarAcimaAbaixoDiag =====================
; Troca matriz[i][j] com matriz[j][i] apenas quando i < j
TrocarAcimaAbaixoDiag PROC
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov bx,0            ; i = 0

For_i:
    mov cx,bx           ; j = i+1
    inc cx

For_j:
    cmp cx,N
    jge Next_i

    ; matriz[i][j]
    mov ax,bx           ; AX = i
    mov dl,N
    mul dl              ; AX = i*N
    add ax,cx           ; AX = i*N + j
    mov si, offset matriz
    add si, ax
    mov al, [si]        ; al = matriz[i][j]

    ; matriz[j][i]
    mov ax,cx           ; AX = j
    mov dl,N
    mul dl              ; AX = j*N
    add ax,bx           ; AX = j*N + i
    mov di, offset matriz
    add di, ax
    mov ah, [di]        ; ah = matriz[j][i]

    ; troca
    mov [si], ah
    mov [di], al

    inc cx
    jmp For_j

Next_i:
    inc bx
    cmp bx, N-1
    jl For_i

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
TrocarAcimaAbaixoDiag ENDP


; ===================== PROCEDIMENTO: ImprimirMatriz =====================
ImprimirMatriz PROC
    push ax
    push bx
    push cx

    mov dx, offset msgRes
    call PrintStr

    mov bx, offset matriz
    mov cx, N*N

    mov si,0
Linha:
    mov di, N
Coluna:
    mov al, [bx+si]
    add al,'0'
    mov dl, al
    mov ah, 02h
    int 21h

    mov dl, ' '
    mov ah, 02h
    int 21h

    inc si
    dec di
    jnz Coluna

    mov dl,0Dh
    mov ah,02h
    int 21h
    mov dl,0Ah
    int 21h

    sub cx, N
    jnz Linha

    pop cx
    pop bx
    pop ax
    ret
ImprimirMatriz ENDP


; =============================== MAIN ===============================
main PROC
    mov ax, @data
    mov ds, ax

    call LerMatriz
    call TrocarAcimaAbaixoDiag
    call ImprimirMatriz

    mov ah,4Ch
    int 21h
main ENDP

end main
