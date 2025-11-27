; Procedimento: Multiplica AX por 2^CL
; Entrada:
;   AX = número a ser multiplicado
;   CL = potência de 2 (ex: CL=3 → AX * 2³ = AX * 8)
; Saída:
;   AX = resultado atualizado
; Registradores preservados: nenhum (AX já é o resultado)

MulPot2 PROC
    ; CL já contém o número de deslocamentos
    ; SHL AX, CL multiplica AX por 2^CL
    shl ax, cl
    ret
MulPot2 ENDP
