; Jogo da Velha — Jogador x Computador (8086, 16 bits)
; TASM/MASM/emu8086
.MODEL SMALL
.STACK 100h

.DATA
tab         DB '1','2','3','4','5','6','7','8','9'
hum         DB 'X'
pc          DB 'O'
vez         DB 'X'
jog         DB 0
ult         DB 0

t1          DB 13,10,'Jogo da Velha (X vs PC)',13,10,'$'
p1          DB 13,10,'Sua vez (',0,'). 1-9: $'         ; placeholder em +10
inv         DB 13,10,'Invalido.',13,10,'$'
occ         DB 13,10,'Ocupado.',13,10,'$'
tp          DB 13,10,'PC jogando...',13,10,'$'
pj          DB 'PC jogou na casa ',0,13,10,'$'         ; placeholder em +18
vw          DB 13,10,'Vitoria de ',0,13,10,'$'         ; placeholder em +12
ep          DB 13,10,'Empate.',13,10,'$'
fim         DB 13,10,'Fim.',13,10,'$'
sep         DB 13,10,'---+---+---',13,10,'$'
nl          DB 13,10,'$'

.CODE
MAIN PROC
    mov ax, @DATA
    mov ds, ax

    call reset

inicio:
    lea dx, t1
    mov ah, 09h
    int 21h
    call draw

turno:
    mov al, vez
    cmp al, hum
    jne turno_pc

; --------- HUMANO ---------
turno_hum:
    mov al, hum
    mov BYTE PTR p1+10, al
    lea dx, p1
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    cmp al, '1'
    jb  msg_inv
    cmp al, '9'
    ja  msg_inv

    sub al, '1'
    mov bl, al
    xor bh, bh
    mov si, bx

    mov al, tab[si]
    cmp al, 'X'
    je  msg_occ
    cmp al, 'O'
    je  msg_occ

    mov al, hum
    mov tab[si], al
    mov ult, bl
    inc jog

    call crlf
    call draw

    push ax
    mov al, hum
    call win_for
    cmp al, 1
    pop ax
    je  ganhou_hum

    mov al, jog
    cmp al, 9
    je  empate

    mov al, pc
    mov vez, al
    jmp turno_pc

msg_inv:
    lea dx, inv
    mov ah, 09h
    int 21h
    jmp turno_hum

msg_occ:
    lea dx, occ
    mov ah, 09h
    int 21h
    jmp turno_hum

; --------- COMPUTADOR ---------
turno_pc:
    lea dx, tp
    mov ah, 09h
    int 21h

    call ia_joga

    mov al, ult
    add al, '1'
    mov BYTE PTR pj+18, al
    lea dx, pj
    mov ah, 09h
    int 21h

    call draw

    push ax
    mov al, pc
    call win_for
    cmp al, 1
    pop ax
    je  ganhou_pc

    mov al, jog
    cmp al, 9
    je  empate

    mov al, hum
    mov vez, al
    jmp turno_hum

ganhou_hum:
    mov BYTE PTR vw+12, 'X'
    lea dx, vw
    mov ah, 09h
    int 21h
    jmp sair

ganhou_pc:
    mov BYTE PTR vw+12, 'O'
    lea dx, vw
    mov ah, 09h
    int 21h
    jmp sair

empate:
    lea dx, ep
    mov ah, 09h
    int 21h

sair:
    lea dx, fim
    mov ah, 09h
    int 21h

    mov ax, 4C00h
    int 21h
MAIN ENDP

; ---------- util ----------
crlf PROC
    lea dx, nl
    mov ah, 09h
    int 21h
    ret
crlf ENDP

reset PROC
    mov BYTE PTR tab+0, '1'
    mov BYTE PTR tab+1, '2'
    mov BYTE PTR tab+2, '3'
    mov BYTE PTR tab+3, '4'
    mov BYTE PTR tab+4, '5'
    mov BYTE PTR tab+5, '6'
    mov BYTE PTR tab+6, '7'
    mov BYTE PTR tab+7, '8'
    mov BYTE PTR tab+8, '9'
    mov vez, 'X'
    mov jog, 0
    mov ult, 0
    ret
reset ENDP

draw PROC
    ; linha 1 (0..2)
    mov dl, ' '
    mov ah, 02h
    int 21h
    mov dl, tab[0]
    int 21h
    mov dl, ' '
    int 21h
    mov dl, '|'
    int 21h
    mov dl, ' '
    int 21h
    mov dl, tab[1]
    int 21h
    mov dl, ' '
    int 21h
    mov dl, '|'
    int 21h
    mov dl, ' '
    int 21h
    mov dl, tab[2]
    int 21h
    call crlf

    lea dx, sep
    mov ah, 09h
    int 21h

    ; linha 2 (3..5)
    mov dl, ' '
    mov ah, 02h
    int 21h
    mov dl, tab[3]
    int 21h
    mov dl, ' '
    int 21h
    mov dl, '|'
    int 21h
    mov dl, ' '
    int 21h
    mov dl, tab[4]
    int 21h
    mov dl, ' '
    int 21h
    mov dl, '|'
    int 21h
    mov dl, ' '
    int 21h
    mov dl, tab[5]
    int 21h
    call crlf

    lea dx, sep
    mov ah, 09h
    int 21h

    ; linha 3 (6..8)
    mov dl, ' '
    mov ah, 02h
    int 21h
    mov dl, tab[6]
    int 21h
    mov dl, ' '
    int 21h
    mov dl, '|'
    int 21h
    mov dl, ' '
    int 21h
    mov dl, tab[7]
    int 21h
    mov dl, ' '
    int 21h
    mov dl, '|'
    int 21h
    mov dl, ' '
    int 21h
    mov dl, tab[8]
    int 21h
    call crlf
    ret
draw ENDP

; verifica vitoria do simbolo em AL (retorna AL=1 se venceu, 0 caso contrario)
win_for PROC
    push bx
    mov  bl, al

    ; linhas
    mov  al, tab[0]
    cmp  al, bl
    jne  wf_l2
    mov  al, tab[1]
    cmp  al, bl
    jne  wf_l2
    mov  al, tab[2]
    cmp  al, bl
    jne  wf_l2
    mov  al, 1
    jmp  wf_end

wf_l2:
    mov  al, tab[3]
    cmp  al, bl
    jne  wf_l3
    mov  al, tab[4]
    cmp  al, bl
    jne  wf_l3
    mov  al, tab[5]
    cmp  al, bl
    jne  wf_l3
    mov  al, 1
    jmp  wf_end

wf_l3:
    mov  al, tab[6]
    cmp  al, bl
    jne  wf_c1
    mov  al, tab[7]
    cmp  al, bl
    jne  wf_c1
    mov  al, tab[8]
    cmp  al, bl
    jne  wf_c1
    mov  al, 1
    jmp  wf_end

    ; colunas
wf_c1:
    mov  al, tab[0]
    cmp  al, bl
    jne  wf_c2
    mov  al, tab[3]
    cmp  al, bl
    jne  wf_c2
    mov  al, tab[6]
    cmp  al, bl
    jne  wf_c2
    mov  al, 1
    jmp  wf_end

wf_c2:
    mov  al, tab[1]
    cmp  al, bl
    jne  wf_c3
    mov  al, tab[4]
    cmp  al, bl
    jne  wf_c3
    mov  al, tab[7]
    cmp  al, bl
    jne  wf_c3
    mov  al, 1
    jmp  wf_end

wf_c3:
    mov  al, tab[2]
    cmp  al, bl
    jne  wf_d1
    mov  al, tab[5]
    cmp  al, bl
    jne  wf_d1
    mov  al, tab[8]
    cmp  al, bl
    jne  wf_d1
    mov  al, 1
    jmp  wf_end

    ; diagonais
wf_d1:
    mov  al, tab[0]
    cmp  al, bl
    jne  wf_d2
    mov  al, tab[4]
    cmp  al, bl
    jne  wf_d2
    mov  al, tab[8]
    cmp  al, bl
    jne  wf_d2
    mov  al, 1
    jmp  wf_end

wf_d2:
    mov  al, tab[2]
    cmp  al, bl
    jne  wf_no
    mov  al, tab[4]
    cmp  al, bl
    jne  wf_no
    mov  al, tab[6]
    cmp  al, bl
    jne  wf_no
    mov  al, 1
    jmp  wf_end

wf_no:
    xor  al, al

wf_end:
    pop  bx
    ret
win_for ENDP

; IA: ganhar > bloquear > centro > primeira livre
ia_joga PROC
    push ax
    push bx
    push cx
    push si

    ; 1) tentar ganhar agora
    mov cx, 9
    mov si, 0
ij_gain_loop:
    mov al, tab[si]
    cmp al, 'X'
    je  ij_gain_next
    cmp al, 'O'
    je  ij_gain_next

    mov bl, tab[si]
    mov al, pc
    mov tab[si], al

    push ax
    mov al, pc
    call win_for
    cmp al, 1
    pop ax
    jne ij_gain_undo

    jmp ij_done

ij_gain_undo:
    mov tab[si], bl

ij_gain_next:
    inc si
    dec cx
    jz  ij_gain_end
    jmp ij_gain_loop
ij_gain_end:

    ; 2) bloquear humano
    mov cx, 9
    mov si, 0
ij_blk_loop:
    mov al, tab[si]
    cmp al, 'X'
    je  ij_blk_next
    cmp al, 'O'
    je  ij_blk_next

    mov bl, tab[si]
    mov al, hum
    mov tab[si], al

    push ax
    mov al, hum
    call win_for
    cmp al, 1
    pop ax
    jne ij_blk_undo

    mov al, pc
    mov tab[si], al
    jmp ij_done

ij_blk_undo:
    mov tab[si], bl

ij_blk_next:
    inc si
    dec cx
    jz  ij_blk_end
    jmp ij_blk_loop
ij_blk_end:

    ; 3) centro
    mov si, 4
    mov al, tab[si]
    cmp al, 'X'
    je  ij_first
    cmp al, 'O'
    je  ij_first
    mov al, pc
    mov tab[si], al
    jmp ij_done

    ; 4) primeira livre
ij_first:
    mov cx, 9
    mov si, 0
ij_f_loop:
    mov al, tab[si]
    cmp al, 'X'
    je  ij_f_next
    cmp al, 'O'
    je  ij_f_next
    mov al, pc
    mov tab[si], al
    jmp ij_done
ij_f_next:
    inc si
    dec cx
    jz  ij_none
    jmp ij_f_loop
ij_none:

ij_done:
    mov ax, si
    mov ult, al
    inc jog

    pop si
    pop cx
    pop bx
    pop ax
    ret
ia_joga ENDP

END MAIN