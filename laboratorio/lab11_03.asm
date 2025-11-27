; Procedimento: Converte letra maiúscula em minúscula usando XLAT
; Entrada: AL = caractere maiúsculo ('A'..'Z')
; Saída:   AL = caractere minúsculo ('a'..'z')

ConvertMaiuscula PROC
    push bx            ; salva BX para não afetar o chamador

    mov bx, offset TabelaMinusculas   ; BX aponta para a tabela
    sub al, 'A'        ; transforma AL em índice (0..25)
    xlat               ; AL = tabela[AL]

    pop bx             ; restaura BX
    ret
ConvertMaiuscula ENDP

;  Tabela de conversão A->a, B->b, Z->z
TabelaMinusculas db 'abcdefghijklmnopqrstuvwxyz'
