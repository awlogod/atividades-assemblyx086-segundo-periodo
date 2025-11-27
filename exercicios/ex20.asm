title Soma de dois caracteres numéricos
.model small
.stack 100h
.data
    msg1 db 'Digite um numero entre 0 e 9: $'
    msg2 db 0Dh,0Ah,'Digite outro numero entre 0 e 9: $'
    msg3 db 0Dh,0Ah,'Resultado e: $'
.code
main proc

    mov ax, @data
    mov ds, ax

    ;ler a primeira mensagem
    mov ah, 09h
    lea dx, msg1
    int 21h

    ;ler o caracter
    mov ah, 01h
    int 21h
    sub al, 30h
    mov bl, al


    ;ler a segunda mensagem
    mov ah, 09h
    lea dx, msg2
    int 21h

    ;ler o caracter
    mov ah, 01h
    int 21h
    sub al, 30h

    add bl, al

    add bl, 30h


    ;mostrar a mensagem de resultado
    mov ah, 09h
    lea dx, msg3
    int 21h

    ;mostrar o caracter
    mov ah, 02h
    mov dl, bl
    int 21h

    mov ah, 4ch
    int 21h
main endp
end main