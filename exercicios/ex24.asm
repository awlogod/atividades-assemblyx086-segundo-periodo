title Crie um vetor de 5 números e mostre o maior valor
.model small
.stack 100h
.data
    vetor db '1,2,3,4,5'
.code
main proc

    mov ax, @data
    mov ds, ax


    mov si, offset vetor   ; SI aponta pro primeiro elemento
    mov cx, 5

    mov al, vetor
    mov bl, '0'

    cmp al, bl
    jg maior
    jl menor

maior:

