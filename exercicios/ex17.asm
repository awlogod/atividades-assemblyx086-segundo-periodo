title Loop com contador
.model small
.stack 100h
.data
.code
main proc
mov ax, @data
mov ds, ax

mov cx, 10
mov ah, 02
mov dl, '#'

repetir:
mov ah, 02h
int 21h
LOOP repetir

mov ah, 4ch
int 21h

main endp
end main