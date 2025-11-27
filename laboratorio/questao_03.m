%-----------------------------------------------------------
%        Questão 3 - TVC 2 (versão totalmente comentada)
%-----------------------------------------------------------

clear; clc; close all;                 % Limpa variáveis, limpa terminal e fecha janelas gráficas

pkg load symbolic                      % Carrega o pacote simbólico do Octave (necessário para manipular expressões simbólicas)

% Declara parâmetros simbólicos gerais usados na matriz D-H
syms d_var theta_var a_var alpha_var   % Cria variáveis simbólicas para d, θ, a e α

% Crio constantes simbólicas 0 e 1 (útil para manter a matriz simbólica)
S0 = sym(0);                           % Cria o número zero como simbólico
S1 = sym(1);                           % Cria o número um como simbólico


%-----------------------------------------------------------
%          MATRIZES ELEMENTARES DE TRANSFORMAÇÃO
%-----------------------------------------------------------

% Matriz de translação ao longo do eixo x (move o sistema no eixo x)
T_x = [ S1  S0  S0  a_var;             % Adiciona deslocamento a_var no eixo x
        S0  S1  S0  S0;
        S0  S0  S1  S0;
        S0  S0  S0  S1 ];              % Linha de homogeneização (obrigatória em matrizes 4x4)

% Matriz de translação ao longo do eixo z (move o sistema no eixo z)
T_z = [ S1  S0  S0  S0;
        S0  S1  S0  S0;
        S0  S0  S1  d_var;             % Adiciona deslocamento d_var no eixo z
        S0  S0  S0  S1 ];

% Matriz de rotação em torno do eixo x
R_x = [ S1  S0           S0              S0;      % Não altera x
        S0  cos(alpha_var) -sin(alpha_var) S0;     % Rotação no plano yz
        S0  sin(alpha_var)  cos(alpha_var) S0;
        S0  S0           S0              S1 ];

% Matriz de rotação em torno do eixo z
R_z = [ cos(theta_var)  -sin(theta_var)  S0  S0;   % Rotação no plano xy
        sin(theta_var)   cos(theta_var)  S0  S0;
        S0               S0              S1  S0;   % Mantém z inalterado
        S0               S0              S0  S1 ];

% Matriz geral de transformação Denavit–Hartenberg
A_DH = simplify(T_z * R_z * T_x * R_x); % Multiplica as quatro matrizes e simplifica a expressão final


%-----------------------------------------------------------
%       TABELA D–H DO ROBÔ (PARÂMETROS DO EXERCÍCIO)
%-----------------------------------------------------------

syms D1 th1 th2 th3 a2 a3 real          % Declara variáveis simbólicas reais para os elos

ang90 = sym(pi)/2;                      % Define α = 90° (usado no link 1)

% Substituição dos parâmetros de cada elo na matriz genérica D-H
A_1 = subs(A_DH, [d_var theta_var a_var alpha_var], [D1   th1   S0   ang90]);  
                                        % Matriz de transformação do elo 1

A_2 = subs(A_DH, [d_var theta_var a_var alpha_var], [S0   th2   a2   S0]);
                                        % Matriz de transformação do elo 2

A_3 = subs(A_DH, [d_var theta_var a_var alpha_var], [S0   th3   a3   S0]);
                                        % Matriz de transformação do elo 3

H0 = eye(4);                            % Matriz identidade 4×4 representando a base do robô

%-----------------------------------------------------------
%         MATRIZES DE TRANSFORMAÇÃO PEDIDAS NO EXERCÍCIO
%-----------------------------------------------------------

T_2_3 = A_2 * A_3                       % Transformação do elo 2 para o elo 3
T_1_3 = A_1 * A_2 * A_3                 % Transformação do elo 1 até o elo 3
T_0_3 = H0 * A_1 * A_2 * A_3            % Transformação completa da base até o efetuador final
