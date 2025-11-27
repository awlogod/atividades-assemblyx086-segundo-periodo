TITLE Imprime *

.Model small
.Stack 100h
.DATA
    msg01 DB 'Digite caracteres (Enter para terminar): $'
    count DW 0                    
    asterisk DB '*$'             

.CODE
    MAIN PROC
        MOV AX, @DATA            
        MOV DS, AX

        
        MOV AH, 09h
        LEA DX, msg01
        INT 21h

    READ_LOOP:
        MOV AH, 01h            
        INT 21h
        
        CMP AL, 0Dh             
        JE PRINT_STARS          
        
        INC count               
        JMP READ_LOOP           

    PRINT_STARS:
        MOV CX, count          
        
    STAR_LOOP:
        CMP CX, 0               
        JE EXIT               
        
        MOV AH, 09h            
        LEA DX, asterisk
        INT 21h
        
        DEC CX              
        JMP STAR_LOOP          

    EXIT:
        MOV AH, 4Ch            
        INT 21h
    MAIN ENDP
END MAIN