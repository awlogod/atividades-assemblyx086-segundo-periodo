title exemplo
.model small
.data
msg db 'ola bem vindo',13,10,'$'
.code
main proc
mov ax,@data ; inicializar DS com endereco do segmento de dados
mov ds,ax
mov ah,09 ; funcao 09 impirme um string
mov dx, offset msg ; endereço incial do string
int 21h ; executa a funcao 09
mov ah,4ch ; fim do programa
int 21h ; retorno ao SO
main endp
end main