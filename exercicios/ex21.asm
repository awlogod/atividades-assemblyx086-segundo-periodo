title Loop decrescente
.model small
.stack 100h
.data
.code
main proc
    mov ax, @data
    mov ds, ax

    mov dl, '9'         ; começa do caractere '9'

repetir:
    mov ah, 02h
    int 21h             ; mostra número

    ; quebra de linha
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    dec dl              ; decrementa o caractere
    cmp dl, '0'         ; chegou no '0'?
    jge repetir         ; se ainda >= '0', continua o loop

    mov ah, 4Ch
    int 21h
main endp
end main
