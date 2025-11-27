title Entrada e eco
.model small
.stack 100h
.data
    msg1 db "Digite um caracter: $"
    msg2 db "Voce digitou: $"
.code
main proc

    mov ax, @data
    mov ds, ax
;imprimir a primeira mensagem

    mov ah, 09h
    lea dx, msg1
    int 21h

; le o caracter
    mov ah, 01h
    int 21h
    mov bl, al

;imprimir o caracter
mov ah, 09h
lea dx, msg2
int 21h

;mostrar o caracter
mov ah, 02h
mov dl, bl
int 21h

mov ah, 4ch
int 21h

main endp
end main