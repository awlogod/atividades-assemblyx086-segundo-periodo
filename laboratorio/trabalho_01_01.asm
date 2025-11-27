; ================================================================
;  JOGO DA VELHA - Jogador x Jogador (8086 - 16 bits)
;  Montador: MASM/TASM/emu8086
;  Objetivo: jogo da velha simples no console (DOS), 2 jogadores.
;  Controles: digite de 1 a 9 para marcar a casa correspondente.
;  Autor: (seu nome)
;  Data: 2025-10-13
; ================================================================

.MODEL SMALL
.STACK 100h

.DATA
    ; --- Estado do jogo ---
    tabuleiro      DB '1','2','3','4','5','6','7','8','9'  ; casas 1..9
    jogador_atual  DB 'X'                                   ; alterna entre 'X' e 'O'
    jogadas        DB 0                                     ; contador de jogadas (0..9)

    ; --- Mensagens (sem acento para evitar problemas de codepage no DOS) ---
    msgTitulo   DB 13,10,'=== JOGO DA VELHA (Jogador x Jogador) - 8086 ===',13,10,'$'

    ; Colocaremos o caractere do jogador_atual no byte 8 (apos "Jogador ")
    ; "Jogador " = 8 caracteres -> msgVez+8 recebe 'X' ou 'O'
    msgVez      DB 13,10,'Jogador ',0,' - escolha uma casa (1-9): $'

    msgInvalida DB 13,10,'Entrada invalida. Use 1..9 e casa livre.',13,10,'$'
    msgOcupada  DB 13,10,'Casa ocupada! Tente outra.',13,10,'$'

    ; "Vitoria do jogador " = 19 caracteres -> msgVitoria+19 recebe 'X'/'O'
    msgVitoria  DB 13,10,'Vitoria do jogador ',0,'!',13,10,'$'
    msgEmpate   DB 13,10,'Empate! Ninguem venceu.',13,10,'$'
    msgFim      DB 13,10,'Fim do jogo.',13,10,'$'

    separador   DB 13,10,'---+---+---',13,10,'$'
    quebra_linha DB 13,10,'$'

.CODE
MAIN PROC
    ; Inicializa segmento de dados
    mov  ax, @DATA
    mov  ds, ax

    ; Reseta estado inicial do jogo
    call ReiniciarJogo

CicloPrincipal:
    ; Mostra titulo e o tabuleiro atual
    lea  dx, msgTitulo
    mov  ah, 09h
    int  21h

    call DesenharTabuleiro

CicloDaVez:
    ; Mostra de quem e a vez (injeta 'X' ou 'O' na mensagem)
    mov  al, jogador_atual
    mov  BYTE PTR msgVez+8, al           ; posiciona caractere do jogador apos "Jogador "
    lea  dx, msgVez
    mov  ah, 09h
    int  21h

    ; Le uma tecla do teclado (eco padrao do DOS)
    mov  ah, 01h
    int  21h                              ; AL = caractere lido

    ; Valida se esta entre '1' e '9'
    cmp  al, '1'
    jb   EntradaInvalida
    cmp  al, '9'
    ja   EntradaInvalida

    ; Converte '1'..'9' para indice 0..8
    sub  al, '1'                          ; AL = 0..8
    mov  bl, al
    xor  bh, bh
    mov  si, bx

    ; Verifica se a casa esta livre (nao pode ser 'X' ou 'O')
    mov  al, tabuleiro[si]
    cmp  al, 'X'
    je   CasaOcupada
    cmp  al, 'O'
    je   CasaOcupada

    ; Aplica a jogada: grava 'X'/'O' na posicao escolhida
    mov  al, jogador_atual
    mov  tabuleiro[si], al

    ; Incrementa numero de jogadas
    inc  jogadas

    ; Redesenha tabuleiro
    call ImprimirNL
    call DesenharTabuleiro

    ; Verifica se houve vitoria do jogador atual
    call VerificarVitoria
    cmp  al, 1
    je   HouveVitoria

    ; Se nao venceu, verifica se deu empate (9 jogadas)
    mov  al, jogadas
    cmp  al, 9
    je   Empatou

    ; Troca o jogador e volta ao ciclo de jogada
    call TrocarJogador
    jmp  CicloDaVez

EntradaInvalida:
    lea  dx, msgInvalida
    mov  ah, 09h
    int  21h
    jmp  CicloDaVez

CasaOcupada:
    lea  dx, msgOcupada
    mov  ah, 09h
    int  21h
    jmp  CicloDaVez

HouveVitoria:
    ; Mostra mensagem de vitoria com o simbolo do vencedor
    mov  al, jogador_atual
    mov  BYTE PTR msgVitoria+19, al
    lea  dx, msgVitoria
    mov  ah, 09h
    int  21h
    jmp  Finalizar

Empatou:
    lea  dx, msgEmpate
    mov  ah, 09h
    int  21h

Finalizar:
    lea  dx, msgFim
    mov  ah, 09h
    int  21h

    ; Retorna ao DOS
    mov  ax, 4C00h
    int  21h
MAIN ENDP

; ------------------------------------------------
; ReiniciarJogo
; - Restaura as casas '1'..'9'
; - Define jogador_atual = 'X'
; - Zera contador de jogadas
; ------------------------------------------------
ReiniciarJogo PROC
    mov  BYTE PTR tabuleiro+0, '1'
    mov  BYTE PTR tabuleiro+1, '2'
    mov  BYTE PTR tabuleiro+2, '3'
    mov  BYTE PTR tabuleiro+3, '4'
    mov  BYTE PTR tabuleiro+4, '5'
    mov  BYTE PTR tabuleiro+5, '6'
    mov  BYTE PTR tabuleiro+6, '7'
    mov  BYTE PTR tabuleiro+7, '8'
    mov  BYTE PTR tabuleiro+8, '9'
    mov  jogador_atual, 'X'
    mov  jogadas, 0
    ret
ReiniciarJogo ENDP

; ------------------------------------------------
; ImprimirNL
; - Imprime uma quebra de linha (CR+LF) usando INT 21h/AH=09h
; ------------------------------------------------
ImprimirNL PROC
    lea  dx, quebra_linha
    mov  ah, 09h
    int  21h
    ret
ImprimirNL ENDP

; ------------------------------------------------
; DesenharTabuleiro
; - Desenha o tabuleiro no formato:
;    a | b | c
;   ---+---+---
;    d | e | f
;   ---+---+---
;    g | h | i
; - Usa INT 21h/AH=02h para imprimir caractere em DL
; ------------------------------------------------
DesenharTabuleiro PROC
    ; linha 1: (0,1,2)
    mov  dl, ' '       ; espaco
    mov  ah, 02h
    int  21h
    mov  dl, tabuleiro[0]
    int  21h
    mov  dl, ' '
    int  21h
    mov  dl, '|'
    int  21h
    mov  dl, ' '
    int  21h
    mov  dl, tabuleiro[1]
    int  21h
    mov  dl, ' '
    int  21h
    mov  dl, '|'
    int  21h
    mov  dl, ' '
    int  21h
    mov  dl, tabuleiro[2]
    int  21h
    call ImprimirNL

    ; separador
    lea  dx, separador
    mov  ah, 09h
    int  21h

    ; linha 2: (3,4,5)
    mov  dl, ' '
    mov  ah, 02h
    int  21h
    mov  dl, tabuleiro[3]
    int  21h
    mov  dl, ' '
    int  21h
    mov  dl, '|'
    int  21h
    mov  dl, ' '
    int  21h
    mov  dl, tabuleiro[4]
    int  21h
    mov  dl, ' '
    int  21h
    mov  dl, '|'
    int  21h
    mov  dl, ' '
    int  21h
    mov  dl, tabuleiro[5]
    int  21h
    call ImprimirNL

    ; separador
    lea  dx, separador
    mov  ah, 09h
    int  21h

    ; linha 3: (6,7,8)
    mov  dl, ' '
    mov  ah, 02h
    int  21h
    mov  dl, tabuleiro[6]
    int  21h
    mov  dl, ' '
    int  21h
    mov  dl, '|'
    int  21h
    mov  dl, ' '
    int  21h
    mov  dl, tabuleiro[7]
    int  21h
    mov  dl, ' '
    int  21h
    mov  dl, '|'
    int  21h
    mov  dl, ' '
    int  21h
    mov  dl, tabuleiro[8]
    int  21h
    call ImprimirNL

    ret
DesenharTabuleiro ENDP

; ------------------------------------------------
; TrocarJogador
; - Alterna jogador_atual entre 'X' e 'O'
; ------------------------------------------------
TrocarJogador PROC
    mov  al, jogador_atual
    cmp  al, 'X'
    jne  ParaX
    mov  jogador_atual, 'O'
    ret
ParaX:
    mov  jogador_atual, 'X'
    ret
TrocarJogador ENDP

; ------------------------------------------------
; VerificarVitoria
; Saida: AL = 1 se jogador_atual venceu; AL = 0 caso contrario
; Verifica as 8 combinacoes possiveis:
;  Linhas: (0,1,2) (3,4,5) (6,7,8)
;  Colunas: (0,3,6) (1,4,7) (2,5,8)
;  Diagonais: (0,4,8) (2,4,6)
; ------------------------------------------------
VerificarVitoria PROC
    mov  bl, jogador_atual    ; BL = simbolo a verificar

    ; Linha 1: 0,1,2
    mov  al, tabuleiro[0]
    cmp  al, bl
    jne  L2
    mov  al, tabuleiro[1]
    cmp  al, bl
    jne  L2
    mov  al, tabuleiro[2]
    cmp  al, bl
    jne  L2
    mov  al, 1
    ret

L2: ; Linha 2: 3,4,5
    mov  al, tabuleiro[3]
    cmp  al, bl
    jne  L3
    mov  al, tabuleiro[4]
    cmp  al, bl
    jne  L3
    mov  al, tabuleiro[5]
    cmp  al, bl
    jne  L3
    mov  al, 1
    ret

L3: ; Linha 3: 6,7,8
    mov  al, tabuleiro[6]
    cmp  al, bl
    jne  C1
    mov  al, tabuleiro[7]
    cmp  al, bl
    jne  C1
    mov  al, tabuleiro[8]
    cmp  al, bl
    jne  C1
    mov  al, 1
    ret

C1: ; Coluna 1: 0,3,6
    mov  al, tabuleiro[0]
    cmp  al, bl
    jne  C2
    mov  al, tabuleiro[3]
    cmp  al, bl
    jne  C2
    mov  al, tabuleiro[6]
    cmp  al, bl
    jne  C2
    mov  al, 1
    ret

C2: ; Coluna 2: 1,4,7
    mov  al, tabuleiro[1]
    cmp  al, bl
    jne  C3
    mov  al, tabuleiro[4]
    cmp  al, bl
    jne  C3
    mov  al, tabuleiro[7]
    cmp  al, bl
    jne  C3
    mov  al, 1
    ret

C3: ; Coluna 3: 2,5,8
    mov  al, tabuleiro[2]
    cmp  al, bl
    jne  D1
    mov  al, tabuleiro[5]
    cmp  al, bl
    jne  D1
    mov  al, tabuleiro[8]
    cmp  al, bl
    jne  D1
    mov  al, 1
    ret

D1: ; Diagonal 1: 0,4,8
    mov  al, tabuleiro[0]
    cmp  al, bl
    jne  D2
    mov  al, tabuleiro[4]
    cmp  al, bl
    jne  D2
    mov  al, tabuleiro[8]
    cmp  al, bl
    jne  D2
    mov  al, 1
    ret

D2: ; Diagonal 2: 2,4,6
    mov  al, tabuleiro[2]
    cmp  al, bl
    jne  NaoVenceu
    mov  al, tabuleiro[4]
    cmp  al, bl
    jne  NaoVenceu
    mov  al, tabuleiro[6]
    cmp  al, bl
    jne  NaoVenceu
    mov  al, 1
    ret

NaoVenceu:
    xor  al, al      ; AL = 0
    ret
VerificarVitoria ENDP

END MAIN
