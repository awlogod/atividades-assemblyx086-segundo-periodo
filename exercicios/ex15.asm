title moer 5 para al
.model SMALL
.stack 100H
.data
    num1 db 5
    res db ?
.code 
main proc
    mov ax, @DATA
    mov ds, AX

    mov al, num1
    mov bl, al
    add bl, 3
    mov res, BL


    ; converte para caractere ASCII
    add bl, 30h
    
    ;mostra o resultado na tela
    mov ah, 02h
    mov dl, bl
    int 21h

    mov ah, 4Ch
    int 21h

main ENDP
end main 
