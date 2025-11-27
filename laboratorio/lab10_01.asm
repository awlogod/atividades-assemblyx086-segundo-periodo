title Conversor de Bases (BINÁRIO / DECIMAL / HEXADECIMAL)
.model small
.stack 100h
.data
msgInicio     db 0Dh,0Ah,'=== CONVERSOR DE BASES ===',0Dh,0Ah,'$'
msgEntrada    db 0Dh,0Ah,'Escolha a base de ENTRADA: (1) Bin  (2) Dec  (3) Hex -> $'
msgSaida      db 0Dh,0Ah,'Escolha a base de SAÍDA:   (1) Bin  (2) Dec  (3) Hex -> $'
msgNumero     db 0Dh,0Ah,'Digite o número (ENTER para finalizar): $'
msgResultado  db 0Dh,0Ah,'Resultado: $'
msgRepetir    db 0Dh,0Ah,'Deseja converter outro número? (S/N) -> $'
msgErroBase   db 0Dh,0Ah,'[ERRO] Base inválida, tente novamente.',0Dh,0Ah,'$'
msgErroNum    db 0Dh,0Ah,'[ERRO] Número inválido ou muito grande.',0Dh,0Ah,'$'
msgFim        db 0Dh,0Ah,'Programa finalizado. Obrigado por usar!',0Dh,0Ah,'$'
tabelaHex     db '0123456789ABCDEF$'

baseEntrada   db ?
baseSaida     db ?
negativo      db ?

.code

; --------- ROTINAS BÁSICAS DE ENTRADA E SAÍDA ----------
ImprimirTexto PROC       ; Exibe texto terminado com $
    push ax
    mov ah,09h
    int 21h
    pop ax
    ret
ImprimirTexto ENDP

ImprimirCaractere PROC   ; Exibe caractere (DL)
    push ax
    mov ah,02h
    int 21h
    pop ax
    ret
ImprimirCaractere ENDP

LerCaractere PROC        ; Lê caractere do teclado (retorna em AL)
    mov ah,01h
    int 21h
    ret
LerCaractere ENDP

PularLinha PROC          ; Quebra de linha (CR + LF)
    push dx
    mov dl,0Dh
    call ImprimirCaractere
    mov dl,0Ah
    call ImprimirCaractere
    pop dx
    ret
PularLinha ENDP

; --------- LEITURA DA BASE (BIN / DEC / HEX) ----------
LerBase PROC
    call LerCaractere
    sub al,'0'
    cmp al,1
    jb  BaseInvalida
    cmp al,3
    ja  BaseInvalida
    ret
BaseInvalida:
    xor al,al
    ret
LerBase ENDP

; --------- ENTRADA BINÁRIA ----------
LerBinario PROC
    push ax
    push dx
    push cx
    xor bx,bx
    xor cx,cx

LerBinario_Loop:
    call LerCaractere
    cmp al,0Dh
    je  LerBinario_Fim
    cmp al,'0'
    jb  LerBinario_Erro
    cmp al,'1'
    ja  LerBinario_Erro

    shl bx,1
    mov dl,al
    sub dl,'0'
    or  bl,dl

    inc cx
    cmp cx,16
    ja  LerBinario_Erro
    jmp LerBinario_Loop

LerBinario_Erro:
    stc
    jmp LerBinario_Sair

LerBinario_Fim:
    clc

LerBinario_Sair:
    pop cx
    pop dx
    pop ax
    ret
LerBinario ENDP

; --------- SAÍDA BINÁRIA ----------
MostrarBinario PROC
    push ax
    push bx
    push cx
    push dx
    mov cx,16

MostrarBinario_Loop:
    rol bx,1
    jc  EhUm
    mov dl,'0'
    call ImprimirCaractere
    jmp Proximo
EhUm:
    mov dl,'1'
    call ImprimirCaractere
Proximo:
    loop MostrarBinario_Loop

    pop dx
    pop cx
    pop bx
    pop ax
    ret
MostrarBinario ENDP

; --------- ENTRADA HEXADECIMAL ----------
LerHexadecimal PROC
    push ax
    push dx
    push cx
    xor bx,bx
    xor cx,cx

LerHex_Loop:
    call LerCaractere
    cmp al,0Dh
    je  LerHex_Fim

    cmp al,'a'
    jb  LerHex_Maius
    cmp al,'f'
    ja  LerHex_Maius
    sub al,20h
LerHex_Maius:
    cmp al,'0'
    jb  LerHex_Erro
    cmp al,'9'
    jbe LerHex_Num
    cmp al,'A'
    jb  LerHex_Erro
    cmp al,'F'
    ja  LerHex_Erro

    shl bx,4
    mov dl,al
    sub dl,'A'
    add bl,dl
    add bl,10
    inc cx
    cmp cx,4
    ja  LerHex_Erro
    jmp LerHex_Loop

LerHex_Num:
    shl bx,4
    mov dl,al
    sub dl,'0'
    add bl,dl
    inc cx
    cmp cx,4
    ja  LerHex_Erro
    jmp LerHex_Loop

LerHex_Erro:
    stc
    jmp LerHex_Sair

LerHex_Fim:
    clc

LerHex_Sair:
    pop cx
    pop dx
    pop ax
    ret
LerHexadecimal ENDP

; --------- SAÍDA HEXADECIMAL ----------
MostrarHexadecimal PROC
    push ax
    push bx
    push cx
    push dx
    mov cx,4

MostrarHex_Loop:
    mov dl,bh
    shr dl,4
    cmp dl,9
    jbe EhDigito
    add dl,'A'-10
    jmp Mostrar
EhDigito:
    add dl,'0'
Mostrar:
    call ImprimirCaractere
    rol bx,4
    loop MostrarHex_Loop

    pop dx
    pop cx
    pop bx
    pop ax
    ret
MostrarHexadecimal ENDP

; --------- ENTRADA DECIMAL ----------
LerDecimal PROC
    push ax
    push bx
    push dx
    xor ax,ax
    mov negativo,0

    call LerCaractere
    cmp al,'-'
    jne  LerDecimal_Plus
    mov negativo,1
    call LerCaractere
    jmp  LerDecimal_Loop
LerDecimal_Plus:
    cmp al,'+'
    jne  LerDecimal_Loop
    call LerCaractere

LerDecimal_Loop:
    cmp al,0Dh
    je  LerDecimal_Fim
    cmp al,'0'
    jb  LerDecimal_Erro
    cmp al,'9'
    ja  LerDecimal_Erro

    mov bx,10
    mul bx
    mov bl,al
    sub bl,'0'
    add ax,bx

    call LerCaractere
    cmp al,0Dh
    jne LerDecimal_Loop

LerDecimal_Fim:
    cmp negativo,0
    je  Armazena
    neg ax
Armazena:
    mov bx,ax
    clc
    jmp LerDecimal_Sair

LerDecimal_Erro:
    stc
LerDecimal_Sair:
    pop dx
    pop bx
    pop ax
    ret
LerDecimal ENDP

; --------- SAÍDA DECIMAL ----------
MostrarDecimal PROC
    push bx
    push cx
    push dx

    cmp ax,0
    jne  VerificaSinal
    mov dl,'0'
    call ImprimirCaractere
    jmp FimDecimal

VerificaSinal:
    js  NumeroNegativo
    jmp Divisao

NumeroNegativo:
    mov dl,'-'
    call ImprimirCaractere
    neg ax

Divisao:
    xor cx,cx
    mov bx,10
DivisaoLoop:
    xor dx,dx
    div bx
    push dx
    inc cx
    cmp ax,0
    jne DivisaoLoop

ImprimeLoop:
    pop dx
    add dl,'0'
    call ImprimirCaractere
    loop ImprimeLoop

FimDecimal:
    pop dx
    pop cx
    pop bx
    ret
MostrarDecimal ENDP

main PROC
    mov ax,@data
    mov ds,ax

Inicio:
    mov dx,offset msgInicio
    call ImprimirTexto

PerguntaEntrada:
    mov dx,offset msgEntrada
    call ImprimirTexto
    call LerBase
    cmp al,1
    jb  ErroEntrada
    cmp al,3
    ja  ErroEntrada
    mov baseEntrada,al
    jmp PerguntaSaida
ErroEntrada:
    mov dx,offset msgErroBase
    call ImprimirTexto
    jmp PerguntaEntrada

PerguntaSaida:
    mov dx,offset msgSaida
    call ImprimirTexto
    call LerBase
    cmp al,1
    jb  ErroSaida
    cmp al,3
    ja  ErroSaida
    mov baseSaida,al
    jmp LerNumero
ErroSaida:
    mov dx,offset msgErroBase
    call ImprimirTexto
    jmp PerguntaSaida

LerNumero:
    mov dx,offset msgNumero
    call ImprimirTexto

    mov al,baseEntrada
    cmp al,1
    je  FazBinario
    cmp al,2
    je  FazDecimal
    call LerHexadecimal
    jc  NumeroErro
    jmp MostrarResultado
FazBinario:
    call LerBinario
    jc  NumeroErro
    jmp MostrarResultado
FazDecimal:
    call LerDecimal
    jc  NumeroErro

MostrarResultado:
    mov dx,offset msgResultado
    call ImprimirTexto

    mov al,baseSaida
    cmp al,1
    je  SaidaBin
    cmp al,2
    je  SaidaDec
    call MostrarHexadecimal
    jmp Depois
SaidaBin:
    call MostrarBinario
    jmp Depois
SaidaDec:
    mov ax,bx
    call MostrarDecimal

Depois:
    call PularLinha
    mov dx,offset msgRepetir
    call ImprimirTexto
    call LerCaractere
    call PularLinha

    cmp al,'s'
    jne NaoMinusculo
    jmp Inicio
NaoMinusculo:
    cmp al,'S'
    jne Encerrar
    jmp Inicio

Encerrar:
    mov dx,offset msgFim
    call ImprimirTexto
    mov ah,4Ch
    int 21h

NumeroErro:
    mov dx,offset msgErroNum
    call ImprimirTexto
    jmp Inicio

main ENDP
end main
