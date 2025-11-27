title Aritmética com variáveis
.model SMALL
.stack 100H
.data
    num1 db 10
    num2 db 5
    res db ?

.code
main proc
    mov ax, @DATA
    mov ds, ax

    ;move num1 para al
    ;subtrai num2 de al
    ;move res para bl
    mov al, num1
    sub al, num2
    mov res, al
    mov bl, res

    ; converte para caractere ASCII
    add bl, 30h

    ;exibe na tela
    mov ah, 02h
    mov dl, bl
    int 21h

    mov ah, 4Ch
    int 21h

main ENDP
end main