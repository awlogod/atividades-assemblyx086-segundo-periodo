TITLE Jogo da Velha
.MODEL SMALL
.STACK 100H

;-----------------------------------
;              MACROS
;-----------------------------------

TESTA_CASA_IA MACRO CASA ;macro para a IA testar se há algo marcado na casa
      LOCAL VALOR_X
      LOCAL VALOR_O
      LOCAL SAI
      CMP CASA, 'X'
      JE VALOR_X
      CMP CASA, 'O'
      JE VALOR_O
      JMP SAI
      VALOR_X:
      INC DL
      JMP SAI
      VALOR_O:
      INC DH
      SAI:
      ENDM



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
    XOR AX, AX ;zero os valores dos registradores
    XOR DX, DX
    XOR BX, BX
    XOR CX, CX
    
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
    CALL JOGOPVIA ;começa o jogo de jogador contra IA
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
    ;PROCEDIMENTO DO JOGO PVP
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
    MOV BX, 30
    MOV [TURNO+BX], AL
    MOV AH, 9 
    LEA DX, TURNO
    INT 21h

    MOV AH, 1 ; espero pra saber a posição que o jogador quer colocar
    INT 21H

    CMP AL, '9' ;se for acima de 9 ou abaixo de 1 trato como valor invalido
    JA INVALIDOPVP
    CMP AL, '1'
    JB INVALIDOPVP

    CALL CHECACASA ;verifico se a casa está vazia

    TEST CL, CL ;se CL == 0, casa ocupada. e trato como casa inválida
    JZ CASAINVALIDAPVP

    CALL ALTERAMATRIZ ;MODIFICO A MATRIZ
    
    CALL CHECASITUACAOJOGO ;verifico como está a situação do jogo
    
    TEST CL, CL ;se CL == 0, então jogo n acabou, se n declaro o resultado para os usarios
    JZ CONTINUAJOGOPVP
    
    CALL DECLARACAORESULTADO
    JMP FIMDOPVP ;finalizo o jogo

    CONTINUAJOGOPVP:
    CALL ALTERAJOGADOR ; ALTERO O JOGADOR E VOLTO PARA O ÍNICIO DO CICLO
    JMP CICLOJOGOPVP
    
    FIMDOPVP:
    MOV AH, 2 ;line feed para melhor vizualização
    MOV DL, 10
    INT 21H

    MOV AH, 9 ;imprimo a mensagem CLIQUE
    LEA DX, CLIQUE
    INT 21H

    MOV AH, 1 ;espero o enter do úsuario
    INT 21H

    CALL RESETAMATRIZ ;reseto a matriz para o próximo jogo

    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET ;retorno pra chamada

    INVALIDOPVP: ;se o valor for inválida, imprimo mensagem avisando o usuario 
    MOV AH, 9
    LEA DX, NUMEROINVALIDO
    INT 21H
    MOV AH, 1
    INT 21H
    JMP CICLOJOGOPVP ;volto pro inicio do ciclo

    CASAINVALIDAPVP: ;se a casa selecionada for inválida, imprimo mensagem avisando o usuario
    MOV AH, 9
    LEA DX, CASAOCUPADA
    INT 21H
    MOV AH, 1
    INT 21H
    JMP CICLOJOGOPVP ;volto pro inicio do ciclo
 JOGOPVP ENDP

 JOGOPVIA PROC
   ;PROCEDIMENTO DO JOGO PLAYER VS COMPUTADOR
   ;ENTRADA: NENHUMA
   ;SAIDA: NENHUMA 
    PUSH AX ; salvo o conteudo dos registradores para depois 
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    
    CICLOJOGOPVIA:
    CALL IMPRIMETABULEIRO ;imprimo o tabuleiro atual

    MOV AL, JOGADOR_ATUAL ; falo de quem eh o turno
    MOV BX, 30
    MOV [TURNO+BX],AL
    MOV AH, 9
    LEA DX, TURNO
    INT 21H
    
    MOV AH, 1 ;pego o input do usuario
    INT 21H

    CMP AL, '9' ;se for maior que  39h e menor que 31h trato como valor invalido
    JA INVALIDOPVIA
    CMP AL, '1'
    JB INVALIDOPVIA

    CALL CHECACASA ;verifico se a casa está livre

    TEST CL, CL ;se CL == 0, trato a casa como ocupada, logo invalida
    JZ CASAINVALIDAPVIA

    CALL ALTERAMATRIZ ;MODIFICO A MATRIZ
    
    CALL CHECASITUACAOJOGO ;verifico como está a situação do jogo

    TEST CL,CL ;se CL == 0, continua o jogo, se n declaro o resultado e finalizo o jogo
    JZ CONTINUAJOGOPVIA1
    CALL DECLARACAORESULTADO
    JMP FIMDOPVIA

    CONTINUAJOGOPVIA1:
    CALL ALTERAJOGADOR ;altero o jogador atual
    
    IAESCOLHE_OUTRA:
    CALL ESCOLHADAIA ;a IA decide onde jogar

    CALL CHECACASA ;verifico se ela escolheu uma casa adequada

    TEST CL, CL ;se CL == 0, ela escolheu uma casa ocupada, logo ela escolhe outra
    JZ IAESCOLHE_OUTRA

    CALL ALTERAMATRIZ ; altero a matriz com base na escolha dela

    CALL CHECASITUACAOJOGO ;verifico a situação do jogo

    TEST CL, CL ;se CL == 0, continua o jogo, se n declaro o resultado e finalizo o jogo
    JZ CONTINUAJOGOPVIA2
    CALL DECLARACAORESULTADO
    JMP FIMDOPVIA
    
    CONTINUAJOGOPVIA2:
    CALL ALTERAJOGADOR ;altero o jogador retornando para o usuario e reinicio o ciclo
    JMP CICLOJOGOPVIA

    FIMDOPVIA:
    MOV AH, 2 ;line feed para melhor vizualização
    MOV DL, 10
    INT 21H

    MOV AH, 9 ;impirmo mensagem CLIQUE
    LEA DX, CLIQUE
    INT 21H

    MOV AH, 1 ;espero input do usuario
    INT 21H

    CALL RESETAMATRIZ ;reseto a matriz para o próximo jogo

    
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET ;retorno pra chamada

    INVALIDOPVIA: ;se o valor de entrada for inválido, imprimo mensagem avisando o usuario
    MOV AH, 9
    LEA DX, NUMEROINVALIDO
    INT 21H
    MOV AH, 1
    INT 21H
    JMP CICLOJOGOPVIA

    CASAINVALIDAPVIA: ;se a casa estiver ocupada, imprimo mensagem avisando o usuario
    MOV AH, 9
    LEA DX, CASAOCUPADA
    INT 21H
    MOV AH, 1
    INT 21H
    JMP CICLOJOGOPVIA
 JOGOPVIA ENDP

 ESCOLHADAIA PROC
    ;PROCEDIMENTO QUE A IA FAZ A JOGADA
    ;ENTRADA: NENHUMA
    ;SAIDA: CASA ESCOLHIDA EM AL
    PUSH DX
    PUSH CX
    PUSH BX
    PUSH SI

    MOV AL, JOGADAS_FEITAS ;verifico se os turnos são maiores que 3 (agr existe chance de vitoria)
    CMP AL, 3
    JAE ESCOLHAPENSADA ;logo se os turnos forem maior que 3, a IA, pensa em uma jogada
    JMP ESCOLHAALEATORIA ;se n, ela faz uma jogada aleatoria

    ESCOLHAPENSADA:
    ;CHECO AS LINHAS
    XOR BX, BX
    CHECA_PROXIMA_LINHA:
    XOR DX, DX
    MOV CX, 3
    XOR SI, SI
    CHECA_LINHA_ATUAL:
    MOV AL, MATRIZ[BX][SI] ;verifico coluna por coluna averiguando se há X ou O (incrementando DL para X, DH para O)
    
    TESTA_CASA_IA AL

    INC SI 
    LOOP CHECA_LINHA_ATUAL
    
    CMP DH, 2 ;se DH == 2, então há chance de vítoria para o bot então tenta descobrir onde jogar, se n continuo
    JNE VER_O_LINHA
    JMP DESCOBRIU_LINHA
    
    VER_O_LINHA:
    CMP DL, 2 ; se DL == 2, então há chance de vitoria para o usuario, então tenta descobrir onde jogar
    JNE PROXIMA_LINHA
    JMP DESCOBRIU_LINHA
    
    PROXIMA_LINHA: ;se nessa linha n tem chance de vitoria, vou para a próxima
    ADD BX, 3
    CMP BX, 6
    JBE CHECA_PROXIMA_LINHA ; se em nenhuma linha tiver chance de vitoria, verifico se há nas colunas
    
    ;CHECO AS COLUNAS
    XOR SI, SI
    CHECA_PROXIMA_COLUNA:
    XOR DX, DX
    MOV CX, 3
    XOR BX, BX
    CHECA_COLUNA_ATUAL:
    MOV AL, MATRIZ[BX][SI] ;verifico linha por linha averiguando se há X ou O (incrementando DL para X, DH para O)

    TESTA_CASA_IA AL

    ADD BX, 3
    LOOP CHECA_COLUNA_ATUAL

    CMP DH, 2 ;se DH == 2, então há chance de vítoria para o bot então tenta descobrir onde jogar, se n continuo
    JNE VER_O_COLUNA
    JMP DESCOBRIU_COLUNA
    
    VER_O_COLUNA:
    CMP DL, 2 ; se DL == 2, então há chance de vitoria para o usuario, então tenta descobrir onde jogar
    JNE PROXIMA_COLUNA
    JMP DESCOBRIU_COLUNA
    
    PROXIMA_COLUNA: ;se nessa coluna n tem chance de vitoria, vou para a próxima
    INC SI
    CMP SI, 3
    JNZ CHECA_PROXIMA_COLUNA ; se em nenhuma coluna tiver chance de vitoria, verifico se há na diagonal principal

    ;CHECO A DIAGONA PRINCIPAL
    XOR DX, DX
    XOR BX, BX
    XOR SI, SI
    MOV CX, 3
    PRIMEIRA_DIAGONAL:
    MOV AL, MATRIZ[BX][SI] ;verifico se há X ou O (incrementando DL para X, DH para O)
    
    TESTA_CASA_IA AL
    
    ADD BX, 3
    INC SI
    LOOP PRIMEIRA_DIAGONAL
    
    CMP DH, 2 ;se DH == 2, então há chance de vítoria para o bot então tenta descobrir onde jogar, se n continuo
    JNE VER_O_DIAGONAL1
    JMP DESCOBRIU_DIAGONAL1
    
    VER_O_DIAGONAL1:
    CMP DL, 2 ; se DL == 2, então há chance de vitoria para o usuario, então tenta descobrir onde jogar
    JNE PROXIMA_DIAGONAL
    JMP DESCOBRIU_DIAGONAL1
    PROXIMA_DIAGONAL: ;se não haver chance de vitoria na diagonal principal, verifico a diagonal secundaria
    
    ;SEGUNDA DAIGONAL
    XOR DX, DX
    XOR BX, BX
    MOV SI, 2
    MOV CX, 3
    SEGUNDA_DIAGONAL:
    MOV AL, MATRIZ[BX][SI] ;verifico se há X ou O (incrementando DL para X, DH para O)

    TESTA_CASA_IA AL

    ADD BX, 3
    DEC SI
    LOOP SEGUNDA_DIAGONAL

    CMP DH, 2 ;se DH == 2, então há chance de vítoria para o bot então tenta descobrir onde jogar, se n continuo
    JNE VER_O_DIAGONAL2
    JMP DESCOBRIU_DIAGONAL2
    
    VER_O_DIAGONAL2:
    CMP DL, 2 ; se DL == 2, então há chance de vitoria para o usuario, então tenta descobrir onde jogar
    JNE ESCOLHAALEATORIA ; se n tiver chance de vitoria em nenhuma das linhas, escolhe aleatorio
    JMP DESCOBRIU_DIAGONAL2
    
    ;CASO A VITORIA ESTEJA EM UMA DAS LINHAS PEGO A POSIÇÃO DELA
    DESCOBRIU_LINHA:
    XOR SI, SI
    MOV CX, 3
    CHECA_CASA_LINHA:
    MOV AL, MATRIZ [BX][SI] ;se na posição atual existe algo menor que 39h, logo ela eh uma posição vazia
    CMP AL, 39H
    JBE ESCOLHAFEITA ;a IA fez sua decisão
    INC SI 
    LOOP CHECA_CASA_LINHA 
    JMP PROXIMA_LINHA ;se n houver posição vazia, então volto para a verificação de chance de vitoria
    
    ;CASO ESTEJA EM UMA DAS COLUNAS PEGO A POSIÇÃO DELA
    DESCOBRIU_COLUNA:
    XOR BX, BX
    MOV CX, 3
    CHECA_CASA_COLUNA:
    MOV AL, MATRIZ[BX][SI] ;se na posição atual existe algo menor que 39h, logo ela eh uma posição vazia
    CMP AL, 39h
    JBE ESCOLHAFEITA ;a IA fez sua decisão
    ADD BX, 3
    LOOP CHECA_CASA_COLUNA
    JMP PROXIMA_COLUNA ;se n houver posição vazia, então volto para a verificação de chance de vitoria
    
    ;CASO ESTEJA NA PRIMEIRA DEIAGONAL
    DESCOBRIU_DIAGONAL1:
    XOR BX, BX
    XOR SI, SI
    MOV CX, 3
    CHECA_CASA_DIAGONAL1:
    MOV AL, MATRIZ[BX][SI] ;se na posição atual existe algo menor que 39h, logo ela eh uma posição vazia
    CMP AL, 39h
    JBE ESCOLHAFEITA ;a IA fez sua decisão
    ADD BX, 3
    INC SI
    LOOP CHECA_CASA_DIAGONAL1
    JMP PROXIMA_DIAGONAL ;se n houver posição vazia, então volto para a verificação de chance de vitoria
    
    ;CASO ESTEJA NA SEGUNDA DIAGONAL
    DESCOBRIU_DIAGONAL2:
    XOR BX, BX
    MOV SI, 2
    MOV CX, 3
    CHECA_CASA_DIAGONAL2:
    MOV AL, MATRIZ[BX][SI] ;se na posição atual existe algo menor que 39h, logo ela eh uma posição vazia
    CMP AL, 39h
    JBE ESCOLHAFEITA ;a IA fez sua decisão
    ADD BX, 3
    DEC SI
    LOOP CHECA_CASA_DIAGONAL2
    JMP ESCOLHAALEATORIA ;caso n tenha posição vazia, então IA se enganou, escolhe aleatorio.
        
    ESCOLHAFEITA:
    POP SI
    POP BX
    POP CX
    POP DX
    RET ;retorno para a chamada com a decisão da IA

    ESCOLHAALEATORIA:
    MOV AH, 2CH ;função de pegar o tempo atual 
    INT 21h
    
    MOV AL, DL  ; jogo os milesimos em AL
    XOR AH, AH  ; zero AH para fazer divissão 
    MOV CL, 9
    DIV CL      ; divido os milesimos por 9, resto: 0-8
    INC AH      ; incremento 1 para a escolha ser de 1-9 e jogo em AL
    MOV AL, AH
    OR AL, 30H ;transformo em caractere para verificar a casa
    
    JMP ESCOLHAFEITA ;IA fez sua escolha
 ESCOLHADAIA ENDP

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
    
    IMPRIMELINHA:
    OR CX, 19 ;centralizo o tabuleiro
    MOV DL, ' '
    
    ESPACO:
    INT 21H
    LOOP ESPACO
    
    OR CX, 3
    XOR SI,SI
    IMPRIMECOLUNA:
    MOV DL, MATRIZ[BX][SI] ;imprimo o valor a tabela, no meu caso o valor númerico (posição), X ou O
    INT 21H
    CMP SI, 2
    JE PROXIMALINHA ;imprimo o espaço e | para parecer um um sustenido (#)
    MOV DL, ' '
    INT 21H
    MOV DL, '|'
    INT 21H
    MOV DL, ' '
    INT 21H
    INC SI
    LOOP IMPRIMECOLUNA
    
    PROXIMALINHA: ;desço para a proxima linha 
    MOV DL, 10
    INT 21H
    ADD BX, 3
    CMP BX, 6
    JBE IMPRIMELINHA
    
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET ; retorno pra chamada
 IMPRIMETABULEIRO ENDP

 ALTERAMATRIZ PROC
    ;ALTERO A MATRIZ DE ACORDO COM O JOGADOR ATUAL
    ;ENTRADA: MATRIZ ANTES DESSA JOGADA E POSIÇÃO JOGADA EM AL
    ;SAÍDA: MATRIZ ALTERADA
    PUSH AX
    PUSH BX 
    PUSH CX
    PUSH SI
    PUSHF

    XOR BX, BX ;zero BX e SI para fazer o endereçamento
    XOR SI,SI
    MOV CL, JOGADOR_ATUAL ;e coloco o jogador atual (a marcação que vou colocar) em CL
    
    AND AL, 0FH ;Verifico cada posição que o jogador pode selecionar
    CMP AL, 9 ;posição nove
    JE POSICAONOVE
    
    CMP AL, 8 ;posição oito
    JE POSICAOOITO
    
    CMP AL, 7 ;posição sete
    JE POSICAOSETE
    
    CMP AL, 6 ;posição seis 
    JE POSICAOSEIS
    
    CMP AL, 5 ;posição cinco 
    JE POSICAOCINCO
    
    CMP AL, 4 ;posição quatro
    JE POSICAOQUATRO
    
    CMP AL, 3 ;posição tres
    JE POSICAOTRES
    
    CMP AL, 2 ;posição dois
    JE POSICAODOIS
    
    MOV MATRIZ[BX][SI], CL ;e coloco a marcação na posição selecionada e depois pulo para o fim do procedimento
    JMP FIMALTERACAO

    POSICAODOIS: ;posição dois
    MOV SI, 1
    MOV MATRIZ[BX][SI], CL
    JMP FIMALTERACAO

    POSICAOTRES: ;posição tres
    MOV SI, 2
    MOV MATRIZ[BX][SI], CL
    JMP FIMALTERACAO

    POSICAOQUATRO: ;posição quatro
    MOV BX, 3
    MOV MATRIZ[BX][SI], CL
    JMP FIMALTERACAO

    POSICAOCINCO:;posição cinco 
    MOV BX, 3
    MOV SI, 1
    MOV MATRIZ[BX][SI], CL
    JMP FIMALTERACAO

    POSICAOSEIS: ;posição seis 
    MOV BX, 3
    MOV SI, 2
    MOV MATRIZ[BX][SI], CL
    JMP FIMALTERACAO

    POSICAOSETE: ;posição sete
    MOV BX, 6
    MOV MATRIZ[BX][SI], CL
    JMP FIMALTERACAO

    POSICAOOITO: ;posição oito
    MOV BX, 6
    MOV SI, 1
    MOV MATRIZ[BX][SI], CL
    JMP FIMALTERACAO

    POSICAONOVE: ;posição nove
    MOV BX, 6
    MOV SI, 2
    MOV MATRIZ[BX][SI], CL

    FIMALTERACAO:
    POPF
    POP SI
    POP CX
    POP BX
    POP AX
    RET ;retorno ao ponto de chamada
 ALTERAMATRIZ ENDP

 ALTERAJOGADOR PROC
    ;ALTERO O JOGADOR ATUAL
    ;ENTRADA: JOGADOR ATUAL, OQ FEZ A JOGADA
    ;SAIDA: JOGADOR ATUAL, OQ VAI FAZER A PRÓXIMA JOGADA
    PUSH AX ;salvo AX e flags, para ter certeza que n perco conteudo importante, principalment no Player vc IA
    PUSHF
    
    MOV AL, JOGADOR_ATUAL ;coloco o jogador atual em al, e comparo com X
    CMP AL, 'X'
    JE TROCAPROO

    MOV AL, 'X' ;se n for igual, troco para X
    MOV JOGADOR_ATUAL, AL
    JMP TROCOU

    TROCAPROO:

    MOV AL, 'O' ;se for igual troco para O
    MOV JOGADOR_ATUAL, AL

    TROCOU:
    POPF
    POP AX
    RET ;volto ao ponto de chamada
 ALTERAJOGADOR ENDP

 CHECACASA PROC
    ;CHECA A CASA QUE O JOGADOR QUER COLCOCAR PARA TER CERTEZA QUE JÁ NÃO MARCARAM LÁ
    ;ENTRADA: VALOR DA CASA EM AL
    ;SAIDA: PERMISSÃO EM CL, SE 1 CASA VAZIA, SE 0 CASA JÁ MARCADA
    PUSHF ;salvo registradores que serão usados, para retira-los depois
    PUSH AX
    PUSH BX
    PUSH SI

    XOR BX, BX ;zero BX SI E CX para endereçamento e permissão
    XOR SI,SI
    XOR CX, CX
    
    AND AL, 0FH ;transformo entrada do usuario em número, e verifico a posição
    CMP AL, 9 ;posição nove
    JNE CONTINUACHECAOITO
    JMP CHECAPOSICAONOVE
    
    CONTINUACHECAOITO:
    CMP AL, 8 ;posição oito 
    JNE CONTINUACHECASETE 
    JMP CHECAPOSICAOOITO

    CONTINUACHECASETE:
    CMP AL, 7 ;posição sete
    JNE CONTINUACHECASEIS
    JMP CHECAPOSICAOSETE

    CONTINUACHECASEIS:
    CMP AL, 6 ;posição seis
    JNE CONTINUACHECACINCO
    JMP CHECAPOSICAOSEIS

    CONTINUACHECACINCO:
    CMP AL, 5 ;posição cinco
    JNE CONTINUACHECAQUATRO
    JMP CHECAPOSICAOCINCO

    CONTINUACHECAQUATRO:
    CMP AL, 4 ;posição quatro
    JNE CONTINUACHECATRES
    JMP CHECAPOSICAOQUATRO

    CONTINUACHECATRES:
    CMP AL, 3 ;posição tres
    JNE CONTINUACHECADOIS
    JMP CHECAPOSICAOTRES

    CONTINUACHECADOIS:
    CMP AL, 2 ;posição dois
    JNE CONTINUACHECAUM
    JMP CHECAPOSICAODOIS
    
    CONTINUACHECAUM: ;e coloco a marcação na posição selecionada e depois pulo para o fim do procedimento
    MOV AH, MATRIZ[BX][SI] ;posição um
    CMP AH, 'X'
    JE PULACHECAGEMUM
    CMP AH, 'O'
    JE PULACHECAGEMUM
    MOV CL, 1
    PULACHECAGEMUM:
    JMP FIMCHECAGEM

    CHECAPOSICAODOIS: ;posição dois
    MOV SI, 1
    MOV AH, MATRIZ[BX][SI]
    CMP AH, 'X'
    JE PULACHECAGEMDOIS
    CMP AH, 'O'
    JE PULACHECAGEMDOIS
    MOV CL, 1
    PULACHECAGEMDOIS:
    JMP FIMCHECAGEM

    CHECAPOSICAOTRES: ;posição tres
    MOV SI, 2
    MOV AH, MATRIZ[BX][SI]
    CMP AH, 'X'
    JE PULACHECAGEMTRES
    CMP AH, 'O'
    JE PULACHECAGEMTRES
    MOV CL, 1
    PULACHECAGEMTRES:
    JMP FIMCHECAGEM

    CHECAPOSICAOQUATRO: ;posição quatro
    MOV BX, 3
    MOV AH, MATRIZ[BX][SI]
    CMP AH, 'X'
    JE PULACHECAGEMQUATRO
    CMP AH, 'O'
    JE PULACHECAGEMQUATRO
    MOV CL, 1
    PULACHECAGEMQUATRO:
    JMP FIMCHECAGEM

    CHECAPOSICAOCINCO: ;posição cinco
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

    CHECAPOSICAOSEIS: ;posição seis
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

    CHECAPOSICAOSETE: ;posição sete
    MOV BX, 6
    MOV AH, MATRIZ[BX][SI]
    CMP AH, 'X'
    JE PULACHECAGEMSETE
    CMP AH, 'O'
    JE PULACHECAGEMSETE
    MOV CL, 1
    PULACHECAGEMSETE:
    JMP FIMCHECAGEM

    CHECAPOSICAOOITO: ;posição oito 
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

    CHECAPOSICAONOVE: ;posição nove
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
    RET ;volta para o ponto de chamada
 CHECACASA ENDP

 CHECASITUACAOJOGO PROC
    ;CHECA SE O JOGADOR ATUAL GANHOU A PARTIDA
    ;ENTRADA: MATRIZ ALTERADA
    ;SAIDA: RESULTADO EM CL, 1 == VITÓRIA, 2 == EMPATE, 0 == CONTINUA JOGO
    PUSH BX ;salvo os registradores para pega-los depois 
    PUSH SI
    PUSH AX
    PUSH DX
    
    XOR BX, BX ;zero BX SI e CL, para endereçamento de matriz e permissão 
    XOR SI, SI
    XOR CL, CL
    
    MOV AL, JOGADOR_ATUAL ;coloco o jogador atual em AL, para verificar se ele ganhou o jogo

    ;LINHA 1
    MOV DL, MATRIZ[BX][SI] ;testo cada posição da linha, se em uma casa n tiver o jogador atual, vou para proxima linha
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
    MOV CL, 1 ; se o jogador atual estiver marcado em todas as casas em CL 1 (vitória do jogador), pode sair do procedimento
    JMP FIMSITUACAO  

    LINHA2: ;testo cada posição da linha, se em uma casa n tiver o jogador atual, vou para proxima linha
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
    MOV CL, 1 ; se o jogador atual estiver marcado em todas as casas em CL 1 (vitória do jogador), pode sair do procedimento
    JMP FIMSITUACAO

    LINHA3: ;testo cada posição da linha, se em uma casa n tiver o jogador atual, vou para as colunas
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
    MOV CL, 1 ; se o jogador atual estiver marcado em todas as casas em CL 1 (vitória do jogador), pode sair do procedimento
    JMP FIMSITUACAO

    COLUNA1: ;testo cada posição da coluna, se em uma casa n tiver o jogador atual, vou para proxima 
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
    MOV CL, 1 ; se o jogador atual estiver marcado em todas as casas em CL 1 (vitória do jogador), pode sair do procedimento
    JMP FIMSITUACAO

    COLUNA2: ;testo cada posição da coluna, se em uma casa n tiver o jogador atual, vou para proxima 
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
    MOV CL, 1 ; se o jogador atual estiver marcado em todas as casas em CL 1 (vitória do jogador), pode sair do procedimento
    JMP FIMSITUACAO

    COLUNA3: ;testo cada posição da coluna, se em uma casa n tiver o jogador atual, vou para as diagonais
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
    MOV CL, 1 ; se o jogador atual estiver marcado em todas as casas em CL 1 (vitória do jogador), pode sair do procedimento
    JMP FIMSITUACAO

    DIAGONAL1: ;testo cada posição da diagonal, se em uma casa n tiver o jogador atual, vou para proxima 
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
    MOV CL, 1 ; se o jogador atual estiver marcado em todas as casas em CL 1 (vitória do jogador), pode sair do procedimento
    JMP FIMSITUACAO

    DIAGONAL2: ;testo cada posição da coluna, se em uma casa n tiver o jogador atual, ele n ganhou, logo C == 0
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
    MOV CL, 1 ; se o jogador atual estiver marcado em todas as casas em CL 1 (vitória do jogador), pode sair do procedimento
    JMP FIMSITUACAO

    INCREMENTAJOGADA: ;antes de continuar o jogo, verifico se ainda há jogadas possiveis (limite de jogadas 9)
    INC JOGADAS_FEITAS
    MOV AL, JOGADAS_FEITAS
    CMP AL, 9
    JB FIMSITUACAO ;se n houver mais jogadas, CL == 2, ou seja, empate
    MOV CL, 2

    FIMSITUACAO:
    POP DX
    POP AX
    POP SI
    POP BX
    RET ;volto para o ponto de chamda
 CHECASITUACAOJOGO ENDP

 DECLARACAORESULTADO PROC
   ;DECLARA O RESULTADO DA PARTIDA. VITORIA DO JOGADOR ATUAL OU EMPATE
   ;ENTRADA: VALOR DE CL
   ;SAIDA: DECLARAÇÃO IMPRESSA NO TERMINAL
    CALL IMPRIMETABULEIRO ;imprimo o tabuleiro, para mostrar onde o jogador atual ganhou 

    CMP CL, 2 ; verifico se na verdade foi viroria ou empate
    JE EMPATOU 

    MOV AH, 9 ;se vitoria, concateno o jogador atual na string de vitoria, e imprimo a mensagem de vitoria
    MOV AL, JOGADOR_ATUAL
    MOV BX, 19
    MOV [Vitoria+BX], AL
    LEA DX, Vitoria
    INT 21H
    JMP FINALIZAJOGO

    EMPATOU: ;se foi empate, imprimo a mensagem de empate
    MOV AH, 9
    LEA DX, Empate
    INT 21H

    FINALIZAJOGO:
    RET ;volto para o ponto de chamada
 DECLARACAORESULTADO ENDP

 RESETAMATRIZ PROC
   ;RESETA A MATRIZ TRANSFORMANDO ELA PARA O ESTADO NATURAL PARA REUTILIZAÇÃO
   ;ENTRADA: MATRIZ AJUSTADA
   ;SAIDA: MATRIZ RESTAURADA
   PUSH AX ;salvo os registradores para usalos depois
   PUSH BX
   PUSH CX
   PUSH SI

   XOR BX, BX ;zero BX e SI para fazer o endereçamento
   XOR SI, SI

   MOV MATRIZ[BX][SI], 31h ;em cada posiçaõadequada coloco um valor de 1-9 para imprimir na tela do usuario
   ADD SI, 1
   MOV MATRIZ[BX][SI], 32h
   ADD SI, 1
   MOV MATRIZ[BX][SI], 33h
   XOR SI, SI
   ADD BX, 3
   MOV MATRIZ[BX][SI], 34h
   ADD SI, 1
   MOV MATRIZ[BX][SI], 35h
   ADD SI, 1
   MOV MATRIZ[BX][SI], 36h
   XOR SI, SI
   ADD BX, 3
   MOV MATRIZ[BX][SI], 37h
   ADD SI, 1
   MOV MATRIZ[BX][SI], 38h
   ADD SI, 1
   MOV MATRIZ[BX][SI], 39h

   MOV JOGADAS_FEITAS, 0  ;zero os turnos realizados, para n afetar os próximos jogos
   MOV JOGADOR_ATUAL, 'X' ;garanto que o jogador atual é sempre X, 

   POP SI
   POP CX
   POP BX
   POP AX
   RET ;volto para o ponto de chamada
 RESETAMATRIZ ENDP
END MAIN