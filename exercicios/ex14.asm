TITLE Jogo da Velha
.MODEL SMALL
.STACK 100H
.DATA
    ;TELA INICIAL DO JOGO
    TelaIniciotopo DB "         |--------------------------------------------------------------|", 10, 13, '$'
    TelaIniciomeio DB "         |                                                              |", 10, 13, '$'
    Titulojogo     DB "         |                  Bem-Vindo ao Jogo da Velha                  |", 10, 13, '$'
    Escolha        DB "         |                    Escolha o modo de Jogo:                   |", 10, 13, '$'
    Opcao1v1       DB "         |                     2 - Jogador X Jogador                    |", 10, 13, '$'
    Opcap1vIA      DB "         |                     1 - Jogador X IA                         |", 10, 13, '$'
    Opcaosaida     DB "         |                     0 - Sair do Jogo                         |", 10, 13, '$'

    ;MATRIZ DO JOGO
    MATRIZ         DB 31h, 32h, 33h
                   DB 34h, 35h, 36h
                   DB 37h, 38h, 39h

    ;TERMOS DO JOGO
    TURNO          DB 10, 13, "Agora eh o turno do jogador ", 0, 10, 13, 'Escolha uma casa!', 10, 13,'$'
    JOGADOR_ATUAL  DB 'X'
    JOGADAS_FEITAS DB 0
    NUMEROINVALIDO DB 10, 13, "Este numero eh invaladio. Por favor escolha outra.", 10, 13, '$'
    CASAOCUPADA    DB 10, 13, "Esta casa ja esta ocupada. Por favor escolha outra.", 10, 13, '$'

    ;MENSAGENS DE VITÓRIA
    Vitoria        DB "Vitoria do jogador ", 0, '!', 10, 13, '$'
    Empate         DB "Velha! Boa sorte na proxima!$2"
    CLIQUE         DB "CLIQUE ENTER PARA VOLTAR PARA TELA INICIAL...$"
.CODE
 MAIN PROC 
    MOV AX, @DATA ;inicializo DS
    MOV DS, AX

    ReiniciaJogo:
    CALL IMPRIMETELA ;imprimo a tela inicial

    MOV AH, 1 ;pego a escolha do jogador e redireciono ele para a função que ele deseja
    INT 21H
    AND AL, 0FH
    CMP AL, 0
    JE FimJogo
    CMP AL, 1
    JE VersusIA

    CALL JOGOPVP ;começa o jogo de jogador contra jogador
    JMP ReiniciaJogo
    
    VersusIA:
    ;CALL JOGOPVIA ;começa o jogo de jogador contra IA
    JMP ReiniciaJogo ;caso o jogador queira jogar de novo

    FimJogo: ;finalizo o programa
    MOV AH, 4CH
    INT 21H
 MAIN ENDP

 IMPRIMETELA PROC
    ;IMPRIME A TELA INICIAL DO JOGO DA VELHA 
    ;ENTRADA: NENHUMA
    ;SAIDA: NENHUMA
    PUSH AX ;salvo os conteudos dos resgistradores na pilha para no final tirar de lá 
    PUSH BX 
    PUSH CX
    PUSH DX

    MOV AH, 0 
    MOV AL, 6h  ; modo de vídeo CGA 2 cores, 640 X 200
    INT 10H

    MOV AH, 0BH ; esclho a paleta Azul para oq vou escrever
    MOV BH, 1
    MOV BL, 1
    INT 10H
   
    MOV AH, 9 ;imprimo o topo da tela
    LEA DX, TelaIniciotopo
    INT 21H

    MOV CX, 3 ;imprimo o meio repetidas vezes para melhor vizualização
    LEA DX, TelaIniciomeio
    ImprimeMeio:
    INT 21H
    LOOP ImprimeMeio

    LEA DX, Titulojogo ;imprimo o título do jogo
    INT 21H

    LEA DX, Opcao1v1 ; imprimo opção de jogador contra jogador
    INT 21H

    LEA DX, Opcap1vIA ;imprimo opção jogador contra IA
    INT 21H

    LEA DX, Opcaosaida  ;e imprimo a opção de saída
    INT 21H

    MOV CX, 3 ; repito o "Meio" para vizualiazação mais harmonica
    LEA DX, TelaIniciomeio 
    ImprimeFundo:
    INT 21H
    LOOP ImprimeFundo

    POP DX
    POP CX
    POP BX
    POP AX
    RET ; retorno pra chamada
 IMPRIMETELA ENDP

 JOGOPVP PROC
    ;PROCEDIMENTO QUE MARCA O JOGO
    ;ENTRADA: NENHUMA
    ;SAIDA: NENHUMA
    PUSH AX ; salvo o conteudo dos registradores para depois 
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    
    CICLOJOGOPVP:
    CALL IMPRIMETABULEIRO ;imprimo o tabuleiro atual
    
    MOV AL, JOGADOR_ATUAL ; falo de quem eh o turno
    mov BX, 30
    MOV [TURNO+BX], AL
    MOV AH, 9 
    LEA DX, TURNO
    INT 21h

    MOV AH, 1 ; espero pra saber a posição que o jogador quer colocar
    INT 21H

    CMP AL, '9'
    JA INVALIDO
    CMP AL, '1'
    JB INVALIDO

    CALL CHECACASA

    CMP CL, 0
    JE CASAINVALIDA

    CALL ALTERAMATRIZ ;MODIFICO A MATRIZ
    
    CALL CHECASITUACAOJOGO
    TEST CL, CL
    JZ CONTINUAJOGOPVP
    CALL DECLARACAORESULTADO
    JMP FIMDOPVP

    CONTINUAJOGOPVP:
    CALL ALTERAJOGADOR ; ALTERO O JOGADOR
    JMP CICLOJOGOPVP
    
    FIMDOPVP:
    MOV AH, 2
    MOV DL, 10
    INT 21H

    MOV AH, 9
    LEA DX, CLIQUE
    INT 21H

    MOV AH, 1
    INT 21H

    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET ;retorno pra chamada

    INVALIDO:
    MOV AH, 9
    LEA DX, NUMEROINVALIDO
    INT 21H
    MOV AH, 1
    INT 21H
    JMP CICLOJOGOPVP

    CASAINVALIDA:
    MOV AH, 9
    LEA DX, CASAOCUPADA
    INT 21H
    MOV AH, 1
    INT 21H
    JMP CICLOJOGOPVP
 JOGOPVP ENDP

 IMPRIMETABULEIRO PROC
    ;PROCEDIMENTO DE IMPRIMIR O TABULEIRO DURANTE O JOGO
    ;ENTRADA: MATRIZ DO JOGO
    ;SAIDA: NENHUMA
    PUSH AX ;Salvo o conteudo dos registradores e depois tiro eles
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    MOV AH, 0 ; modo de vídeo CGA 2 cores, 640 X 200
    MOV AL, 6h
    INT 10H

    MOV AH, 0BH ;paleta de cor azul
    MOV BH, 1
    MOV BL, 1
    INT 10H
    
    MOV AH, 2 ; imprimo o tabuleiro mas próximo do meio e separado as posições para vizualiação mais harmonica
    XOR CX,CX
    XOR BX,BX
    
    IMPRIMECOLUNA:
    OR CX, 19
    MOV DL, ' '
    
    ESPACO:
    INT 21H
    LOOP ESPACO
    
    OR CX, 3
    XOR SI,SI
    IMPRIMELINHA:
    MOV DL, MATRIZ[BX][SI]
    INT 21H
    CMP SI, 2
    JE PROXIMACOLUNA
    MOV DL, ' '
    INT 21H
    MOV DL, '|'
    INT 21H
    MOV DL, ' '
    INT 21H
    INC SI
    LOOP IMPRIMELINHA
    
    PROXIMACOLUNA:
    MOV DL, 10
    INT 21H
    ADD BX, 3
    CMP BX, 6
    JBE IMPRIMECOLUNA
    
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET ; retorno pra chamada
 IMPRIMETABULEIRO ENDP

 ALTERAMATRIZ PROC
    ;ALTERO A MATRIZ DE ACORDO COM O JOGADOR ATUAL
    ;ENTRADA: MATRIZ ANTES DESSA JOGADA E POSIÇÃO JOGADA
    ;SAÍDA: MATRIZ ALTERADA
    PUSH AX
    PUSH BX 
    PUSH CX
    PUSH SI
    PUSHF

    XOR BX, BX
    XOR SI,SI
    MOV CL, JOGADOR_ATUAL
    
    AND AL, 0FH
    CMP AL, 9
    JE POSICAONOVE
    CMP AL, 8
    JE POSICAOOITO
    CMP AL, 7
    JE POSICAOSETE
    CMP AL, 6
    JE POSICAOSEIS
    CMP AL, 5
    JE POSICAOCINCO
    CMP AL, 4
    JE POSICAOQUATRO
    CMP AL, 3
    JE POSICAOTRES
    CMP AL, 2
    JE POSICAODOIS
    
    MOV MATRIZ[BX][SI], CL
    JMP FIMALTERACAO

    POSICAODOIS:
    MOV SI, 1
    MOV MATRIZ[BX][SI], CL
    JMP FIMALTERACAO

    POSICAOTRES:
    MOV SI, 2
    MOV MATRIZ[BX][SI], CL
    JMP FIMALTERACAO

    POSICAOQUATRO:
    MOV BX, 3
    MOV MATRIZ[BX][SI], CL
    JMP FIMALTERACAO

    POSICAOCINCO:
    MOV BX, 3
    MOV SI, 1
    MOV MATRIZ[BX][SI], CL
    JMP FIMALTERACAO

    POSICAOSEIS:
    MOV BX, 3
    MOV SI, 2
    MOV MATRIZ[BX][SI], CL
    JMP FIMALTERACAO

    POSICAOSETE:
    MOV BX, 6
    MOV MATRIZ[BX][SI], CL
    JMP FIMALTERACAO

    POSICAOOITO:
    MOV BX, 6
    MOV SI, 1
    MOV MATRIZ[BX][SI], CL
    JMP FIMALTERACAO

    POSICAONOVE:
    MOV BX, 6
    MOV SI, 2
    MOV MATRIZ[BX][SI], CL

    FIMALTERACAO:
    POPF
    POP SI
    POP CX
    POP BX
    POP AX
    RET
 ALTERAMATRIZ ENDP

 ALTERAJOGADOR PROC
    ;ALTERO O JOGADOR ATUAL
    ;ENTRADA: JOGADOR ATUAL, OQ FEZ A JOGADA
    ;SAIDA: JOGADOR ATUAL, OQ VAI FAZER A PRÓXIMA JOGADA
    PUSH AX
    PUSHF
    
    MOV AL, JOGADOR_ATUAL
    CMP AL, 'X'
    JE TROCAPROO

    MOV AL, 'X'
    MOV JOGADOR_ATUAL, AL
    JMP TROCOU

    TROCAPROO:

    MOV AL, 'O'
    MOV JOGADOR_ATUAL, AL

    TROCOU:
    POPF
    POP AX
    RET
 ALTERAJOGADOR ENDP

 CHECACASA PROC
    ;CHECA A CASA QUE O JOGADOR QUER COLCOCAR PARA TER CERTEZA QUE JÁ NÃO MARCARAM LÁ
    ;ENTRADA: VALOR DA CASA EM AL
    ;SAIDA: PERMISSÃO EM CL, SE 1 CASA VAZIA, SE 0 CASA JÁ MARCADA
    PUSHF
    PUSH AX
    PUSH BX
    PUSH SI

    XOR BX, BX
    XOR SI,SI
    XOR CX, CX
    
    AND AL, 0FH
    CMP AL, 9
    JNE CONTINUACHECAOITO
    JMP CHECAPOSICAONOVE
    
    CONTINUACHECAOITO:
    CMP AL, 8
    JNE CONTINUACHECASETE 
    JMP CHECAPOSICAOOITO

    CONTINUACHECASETE:
    CMP AL, 7
    JNE CONTINUACHECASEIS
    JMP CHECAPOSICAOSETE

    CONTINUACHECASEIS:
    CMP AL, 6
    JNE CONTINUACHECACINCO
    JMP CHECAPOSICAOSEIS

    CONTINUACHECACINCO:
    CMP AL, 5
    JNE CONTINUACHECAQUATRO
    JMP CHECAPOSICAOCINCO

    CONTINUACHECAQUATRO:
    CMP AL, 4
    JNE CONTINUACHECATRES
    JMP CHECAPOSICAOQUATRO

    CONTINUACHECATRES:
    CMP AL, 3
    JNE CONTINUACHECADOIS
    JMP CHECAPOSICAOTRES

    CONTINUACHECADOIS:
    CMP AL, 2
    JNE CONTINUACHECAUM
    JMP CHECAPOSICAODOIS
    
    CONTINUACHECAUM:
    MOV AH, MATRIZ[BX][SI]
    CMP AH, 'X'
    JE PULACHECAGEMUM
    CMP AH, 'O'
    JE PULACHECAGEMUM
    MOV CL, 1
    PULACHECAGEMUM:
    JMP FIMCHECAGEM

    CHECAPOSICAODOIS:
    MOV SI, 1
    MOV AH, MATRIZ[BX][SI]
    CMP AH, 'X'
    JE PULACHECAGEMDOIS
    CMP AH, 'O'
    JE PULACHECAGEMDOIS
    MOV CL, 1
    PULACHECAGEMDOIS:
    JMP FIMCHECAGEM

    CHECAPOSICAOTRES:
    MOV SI, 2
    MOV AH, MATRIZ[BX][SI]
    CMP AH, 'X'
    JE PULACHECAGEMTRES
    CMP AH, 'O'
    JE PULACHECAGEMTRES
    MOV CL, 1
    PULACHECAGEMTRES:
    JMP FIMCHECAGEM

    CHECAPOSICAOQUATRO:
    MOV BX, 3
    MOV AH, MATRIZ[BX][SI]
    CMP AH, 'X'
    JE PULACHECAGEMQUATRO
    CMP AH, 'O'
    JE PULACHECAGEMQUATRO
    MOV CL, 1
    PULACHECAGEMQUATRO:
    JMP FIMCHECAGEM

    CHECAPOSICAOCINCO:
    MOV BX, 3
    MOV SI, 1
    MOV AH, MATRIZ[BX][SI]
    CMP AH, 'X'
    JE PULACHECAGEMCINCO
    CMP AH, 'O'
    JE PULACHECAGEMCINCO
    MOV CL, 1
    PULACHECAGEMCINCO:
    JMP FIMCHECAGEM

    CHECAPOSICAOSEIS:
    MOV BX, 3
    MOV SI, 2
    MOV AH, MATRIZ[BX][SI]
    CMP AH, 'X'
    JE PULACHECAGEMSEIS
    CMP AH, 'O'
    JE PULACHECAGEMSEIS
    MOV CL, 1
    PULACHECAGEMSEIS:
    JMP FIMCHECAGEM

    CHECAPOSICAOSETE:
    MOV BX, 6
    MOV AH, MATRIZ[BX][SI]
    CMP AH, 'X'
    JE PULACHECAGEMSETE
    CMP AH, 'O'
    JE PULACHECAGEMSETE
    MOV CL, 1
    PULACHECAGEMSETE:
    JMP FIMCHECAGEM

    CHECAPOSICAOOITO:
    MOV BX, 6
    MOV SI, 1
    MOV AH, MATRIZ[BX][SI]
    CMP AH, 'X'
    JE PULACHECAGEMOITO
    CMP AH, 'O'
    JE PULACHECAGEMOITO
    MOV CL, 1
    PULACHECAGEMOITO:
    JMP FIMCHECAGEM

    CHECAPOSICAONOVE:
    MOV BX, 6
    MOV SI, 2
    MOV AH, MATRIZ[BX][SI]
    CMP AH, 'X'
    JE FIMCHECAGEM
    CMP AH, 'O'
    JE FIMCHECAGEM
    MOV CL, 1
    
    FIMCHECAGEM:
    POP SI
    POP BX
    POP AX
    POPF
    RET
 CHECACASA ENDP

 CHECASITUACAOJOGO PROC
    ;CHECA SE O JOGADOR ATUAL GANHOU A PARTIDA
    ;ENTRADA: MATRIZ ALTERADA
    ;SAIDA: RESULTADO EM CL, 1 == VITÓRIA, 2 == EMPATE, 0 == CONTINUA JOGO
    PUSH BX
    PUSH SI
    PUSH AX
    PUSH DX
    
    XOR BX, BX
    XOR SI, SI
    XOR CL, CL
    MOV AL, JOGADOR_ATUAL

    ;LINHA 1
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE LINHA2
    ADD SI, 1
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE LINHA2
    ADD SI, 1
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE LINHA2
    MOV CL, 1
    JMP FIMSITUACAO

    LINHA2:
    XOR SI, SI
    MOV BX, 3
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE LINHA3
    ADD SI, 1
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE LINHA3
    ADD SI, 1
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE LINHA3
    MOV CL, 1
    JMP FIMSITUACAO

    LINHA3:
    XOR SI, SI
    MOV BX, 6
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE COLUNA1
    ADD SI, 1
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE COLUNA1
    ADD SI, 1
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE COLUNA1
    MOV CL, 1
    JMP FIMSITUACAO

    COLUNA1:
    XOR BX, BX
    XOR SI, SI
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE COLUNA2
    ADD BX, 3
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE COLUNA2
    ADD BX, 3
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE COLUNA2
    MOV CL, 1
    JMP FIMSITUACAO

    COLUNA2:
    XOR BX, BX
    MOV SI, 1
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE COLUNA3
    ADD BX, 3
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE COLUNA3
    ADD BX, 3
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE COLUNA3
    MOV CL, 1
    JMP FIMSITUACAO

    COLUNA3:
    XOR BX, BX
    MOV SI, 2
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE DIAGONAL1
    ADD BX, 3
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE DIAGONAL1
    ADD BX, 3
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE DIAGONAL1
    MOV CL, 1
    JMP FIMSITUACAO

    DIAGONAL1:
    XOR BX, BX
    XOR SI, SI
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE DIAGONAL2
    ADD SI, 1
    ADD BX, 3
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE DIAGONAL2
    ADD SI, 1
    ADD BX, 3
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE DIAGONAL2
    MOV CL, 1
    JMP FIMSITUACAO

    DIAGONAL2:
    XOR BX, BX 
    MOV SI, 2
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE INCREMENTAJOGADA
    SUB SI, 1
    ADD BX, 3
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE INCREMENTAJOGADA
    SUB SI, 1
    ADD BX, 3
    MOV DL, MATRIZ[BX][SI]
    CMP AL, DL
    JNE INCREMENTAJOGADA
    MOV CL, 1
    JMP FIMSITUACAO

    INCREMENTAJOGADA:
    INC JOGADAS_FEITAS
    MOV AL, JOGADAS_FEITAS
    CMP AL, 9
    JB FIMSITUACAO
    MOV CL, 2

    FIMSITUACAO:
    POP DX
    POP AX
    POP SI
    POP BX
    RET
 CHECASITUACAOJOGO ENDP

 DECLARACAORESULTADO PROC
   ;DECLARA O RESULTADO DA PARTIDA. VITORIA DO JOGADOR ATUAL OU EMPATE
   ;ENTRADA: VALOR DE CL
   ;SAIDA: DECLARAÇÃO IMPRESSA NO TERMINAL
    CALL IMPRIMETABULEIRO

    CMP CL, 2
    JE EMPATOU 

    MOV AH, 9
    MOV AL, JOGADOR_ATUAL
    MOV BX, 19
    MOV [Vitoria+BX], AL
    LEA DX, Vitoria
    INT 21H
    JMP FINALIZAJOGO

    EMPATOU:
    MOV AH, 9
    LEA DX, Empate
    INT 21H

    FINALIZAJOGO:
    RET   
 DECLARACAORESULTADO ENDP
END MAIN