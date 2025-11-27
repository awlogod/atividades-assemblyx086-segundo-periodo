.model small
.stack 100h
.data
msgTitulo     db 0Dh,0Ah,'=== JOGO DA VELHA 8086 ===',0Dh,0Ah,'$'
msgInstr      db 'Voce joga com X (posicoes 1..9).',0Dh,0Ah,'$'
msgTurnoJ     db 0Dh,0Ah,'Sua vez! Digite uma posicao (1..9): $'
msgInvalido   db 0Dh,0Ah,'[ERRO] Jogada invalida. Tente novamente.',0Dh,0Ah,'$'
msgOcupado    db 0Dh,0Ah,'[ERRO] Posicao ocupada. Tente novamente.',0Dh,0Ah,'$'
msgComp       db 0Dh,0Ah,'Vez do computador (O)...',0Dh,0Ah,'$'
msgXvenceu    db 0Dh,0Ah,'Voce venceu! (X)',0Dh,0Ah,'$'
msgOvenceu    db 0Dh,0Ah,'Computador venceu! (O)',0Dh,0Ah,'$'
msgEmpate     db 0Dh,0Ah,'Empate!',0Dh,0Ah,'$'
msgReiniciar  db 0Dh,0Ah,'Jogar novamente? (S/N): $'

tabuleiro     db '1','2','3','4','5','6','7','8','9'

;Constanet
CR            equ 0Dh
LF            equ 0Ah

.code
; Rotinas de IO simples

; Imprime string $-terminada
PrintStr proc
    mov ah, 09h
    int 21h
    ret
PrintStr endp

; Imprime um caractere presente em DL
PutCh proc
    mov ah, 02h
    int 21h
    ret
PutCh endp
; Imprime CR+LF
NewLine proc
    mov dl, CR
    call PutCh
    mov dl, LF
    call PutCh
    ret
NewLine endp

; Lê um caractere do teclado (retorna em AL)
ReadKey proc
    mov ah, 01h
    int 21h
    ret
ReadKey endp

MostrarTabuleiro proc
    ; Linha 1: [0,1,2]
    call NewLine
    mov dl, ' '   ; espaço
    call PutCh
    mov dl, [tabuleiro+0]
    call PutCh
    mov dl, ' '
    call PutCh
    mov dl, '|'
    call PutCh
    mov dl, ' '
    call PutCh
    mov dl, [tabuleiro+1]
    call PutCh
    mov dl, ' '
    call PutCh
    mov dl, '|'
    call PutCh
    mov dl, ' '
    call PutCh
    mov dl, [tabuleiro+2]
    call PutCh
    call NewLine

    ; Separador
    mov dl, '-'
    call PutCh
    mov dl, '-'
    call PutCh
    mov dl, '-'
    call PutCh
    mov dl, '+'
    call PutCh
    mov dl, '-'
    call PutCh
    mov dl, '-'
    call PutCh
    mov dl, '-'
    call PutCh
    mov dl, '+'
    call PutCh
    mov dl, '-'
    call PutCh
    mov dl, '-'
    call PutCh
    mov dl, '-'
    call PutCh
    call NewLine

    ; Linha 2: [3,4,5]
    mov dl, ' '
    call PutCh
    mov dl, [tabuleiro+3]
    call PutCh
    mov dl, ' '
    call PutCh
    mov dl, '|'
    call PutCh
    mov dl, ' '
    call PutCh
    mov dl, [tabuleiro+4]
    call PutCh
    mov dl, ' '
    call PutCh
    mov dl, '|'
    call PutCh
    mov dl, ' '
    call PutCh
    mov dl, [tabuleiro+5]
    call PutCh
    call NewLine

    ; Separador
    mov dl, '-'
    call PutCh
    mov dl, '-'
    call PutCh
    mov dl, '-'
    call PutCh
    mov dl, '+'
    call PutCh
    mov dl, '-'
    call PutCh
    mov dl, '-'
    call PutCh
    mov dl, '-'
    call PutCh
    mov dl, '+'
    call PutCh
    mov dl, '-'
    call PutCh
    mov dl, '-'
    call PutCh
    mov dl, '-'
    call PutCh
    call NewLine

    ; Linha 3: [6,7,8]
    mov dl, ' '
    call PutCh
    mov dl, [tabuleiro+6]
    call PutCh
    mov dl, ' '
    call PutCh
    mov dl, '|'
    call PutCh
    mov dl, ' '
    call PutCh
    mov dl, [tabuleiro+7]
    call PutCh
    mov dl, ' '
    call PutCh
    mov dl, '|'
    call PutCh
    mov dl, ' '
    call PutCh
    mov dl, [tabuleiro+8]
    call PutCh
    call NewLine

    ret
MostrarTabuleiro endp

CheckWin proc
    ; Usaremos SI para o primeiro indice, etc.
    ; Macro mental: cmp [i], [j], [k] e ve se sao iguais e se sao 'X' ou 'O'

    ; --- Linhas ---
    ; (0,1,2)
    mov al, [tabuleiro+0]
    cmp al, [tabuleiro+1]
    jne CW_next1
    cmp al, [tabuleiro+2]
    jne CW_next1
    cmp al, 'X'
    je CW_retX
    cmp al, 'O'
    je CW_retO
CW_next1:

    ; (3,4,5)
    mov al, [tabuleiro+3]
    cmp al, [tabuleiro+4]
    jne CW_next2
    cmp al, [tabuleiro+5]
    jne CW_next2
    cmp al, 'X'
    je CW_retX
    cmp al, 'O'
    je CW_retO
CW_next2:

    ; (6,7,8)
    mov al, [tabuleiro+6]
    cmp al, [tabuleiro+7]
    jne CW_next3
    cmp al, [tabuleiro+8]
    jne CW_next3
    cmp al, 'X'
    je CW_retX
    cmp al, 'O'
    je CW_retO
CW_next3:

    ; --- Colunas ---
    ; (0,3,6)
    mov al, [tabuleiro+0]
    cmp al, [tabuleiro+3]
    jne CW_next4
    cmp al, [tabuleiro+6]
    jne CW_next4
    cmp al, 'X'
    je CW_retX
    cmp al, 'O'
    je CW_retO
CW_next4:

    ; (1,4,7)
    mov al, [tabuleiro+1]
    cmp al, [tabuleiro+4]
    jne CW_next5
    cmp al, [tabuleiro+7]
    jne CW_next5
    cmp al, 'X'
    je CW_retX
    cmp al, 'O'
    je CW_retO
CW_next5:

    ; (2,5,8)
    mov al, [tabuleiro+2]
    cmp al, [tabuleiro+5]
    jne CW_next6
    cmp al, [tabuleiro+8]
    jne CW_next6
    cmp al, 'X'
    je CW_retX
    cmp al, 'O'
    je CW_retO
CW_next6:

    ; --- Diagonais ---
    ; (0,4,8)
    mov al, [tabuleiro+0]
    cmp al, [tabuleiro+4]
    jne CW_next7
    cmp al, [tabuleiro+8]
    jne CW_next7
    cmp al, 'X'
    je CW_retX
    cmp al, 'O'
    je CW_retO
CW_next7:

    ; (2,4,6)
    mov al, [tabuleiro+2]
    cmp al, [tabuleiro+4]
    jne CW_nowin
    cmp al, [tabuleiro+6]
    jne CW_nowin
    cmp al, 'X'
    je CW_retX
    cmp al, 'O'
    je CW_retO

CW_nowin:
    xor al, al      ; AL = 0 (ninguem venceu)
    ret

CW_retX:
    mov al, 'X'
    ret
CW_retO:
    mov al, 'O'
    ret
CheckWin endp

; Verifica se o tabuleiro esta cheio (empate)
; Retorna ZF=1 (via CMP) se NAO houver casa livre? Nao.
; Vamos retornar em AL:
;   AL=1 -> cheio (empate se ninguem venceu)
;   AL=0 -> ainda ha casas livres
BoardFull proc
    mov cx, 9
    mov si, 0
BF_loop:
    mov al, [tabuleiro+si]
    ; Se ainda houver algum digito '1'..'9', entao nao esta cheio
    cmp al, '1'
    jb  BF_next     ; abaixo de '1' (nao interessa)
    cmp al, '9'
    ja  BF_next     ; acima de '9' (nao interessa)
    ; Achou um numero -> tem livre
    xor al, al      ; AL=0 -> nao esta cheio
    ret
BF_next:
    inc si
    loop BF_loop
    ; Nao encontrou numeros -> cheio
    mov al, 1
    ret
BoardFull endp

; Jogada do jogador (marca 'X'):
; - Pede posicao 1..9
; - Valida intervalo
; - Verifica se a casa esta livre
; - Se ok, marca 'X'

JogadaJogador proc
JJ_ask:
    mov dx, offset msgTurnoJ
    call PrintStr

    call ReadKey           ; tecla em AL
    ; ecoar caractere lido (opcional)
    mov dl, al
    call PutCh
    call NewLine

    ; validar '1'..'9'
    cmp al, '1'
    jb  JJ_inval
    cmp al, '9'
    ja  JJ_inval

    ; converter para indice 0..8: (AL - '1')
    sub al, '1'
    mov bl, al          ; BL = indice 0..8
    ; verificar se casa esta livre: se conteudo eh numero, esta livre
    mov si, bx
    mov al, [tabuleiro+si]
    cmp al, '1'
    jb  JJ_occ
    cmp al, '9'
    ja  JJ_occ

    ; livre -> marcar 'X'
    mov byte ptr [tabuleiro+si], 'X'
    ret

JJ_inval:
    mov dx, offset msgInvalido
    call PrintStr
    jmp JJ_ask

JJ_occ:
    mov dx, offset msgOcupado
    call PrintStr
    jmp JJ_ask
JogadaJogador endp
; Jogada do computador (marca 'O'):
; IA simples: procura a primeira posicao que ainda seja '1'..'9'
JogadaComputador proc
    mov dx, offset msgComp
    call PrintStr

    mov si, 0
JC_loop:
    cmp si, 9
    jge JC_done          ; nenhuma livre (na pratica so acontece em empate)
    mov al, [tabuleiro+si]
    cmp al, '1'
    jb  JC_next
    cmp al, '9'
    ja  JC_next
    ; posicao livre -> marcar 'O'
    mov byte ptr [tabuleiro+si], 'O'
    jmp JC_done
JC_next:
    inc si
    jmp JC_loop
JC_done:
    ret
JogadaComputador endp 
end main
