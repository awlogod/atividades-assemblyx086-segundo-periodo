IMP_VET MACRO ORIGEM, QUANTIDADE 
        LOCAL VOLTA 
        MOV CX, QUANTIDADE
        LEA BX, ORIGEM
        MOV AH, 2
        VOLTA:
        MOV DL, [BX]
        INT 21H
        INC BX
        LOOP VOLTA
        ENDM