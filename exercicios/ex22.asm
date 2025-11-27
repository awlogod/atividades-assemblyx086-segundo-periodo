title Contagem crescente
.model small
.stack 100h
.data
.code
main proc  
    mov ax, @data
    mov ds, ax

    mov dl, '0'

repetir:

    mov ah, 02h
    int 21h

    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    inc dl
    cmp dl, '9'
    jle repetir

    mov ah, 04ch
    int 21h
main endp
end main