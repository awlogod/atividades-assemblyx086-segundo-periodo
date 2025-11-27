title comparacao e salto
.model small
.stack 100h
.data
    num1 db 5 
    num2 db 8
    msg db 'A eh maior$'
    msg2 db 'B eh maior$'
.code
main proc
    mov ax, @data ; inicialização do data
    mov ds, ax

    mov al, num1 ; declaro num1 em al
    mov bl, num2 ; declsaro num2 em bl

    cmp al, bl ; comparo Al com BL (Al - Bl)
    jg maior ; Se for maior, salta para a condicao maior
    jl menor ; se for menor salta apra a condicao menor

    jmp fim ; se for igual, salta para o fim

maior:
    mov ah, 09h
    lea dx, msg ; 
    int 21h
    jmp fim

menor:
    mov ah, 09h
    lea dx, msg2
    int 21h
    jmp fim

fim:
    mov ah, 4ch
    int 21h
main endp
end main