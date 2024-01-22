# next-word

next-word é um game feito pensado numa brincadeira que minha mãe fazia com o pessoal em casa quando faltava luz, pra passar o tempo.

Ela dava uma palavra de 5 letras e a gente precisava formar novas palavras a partir da palavra que ela deu, seguindo algumas regras:

1. Para formar uma nova palavra, poderiam ser trocadas até duas letras.
  1. Se você conseguisse formar uma nova palavra trocando apenas uma letra, você ganharia 2 pontos.
  2. Se trocasse duas, recebia apenas um ponto.
2. Você deve formar uma nova palavra dentro de 30s.
3- Você não pode jogar uma palavra que já foi dita.
4- Se você cometesse algum desses erros, você acumularia um erro e passaria a sua vez, exceto se não conseguisse formar uma palavra dentro de 30s, pois seria eliminado do jogo.
5- O limite de erros era definido no início do jogo e aquele que alcançasse esse limite era eliminado.
6- O vencedor era o último jogador restante.

Trazendo isso para uma linguagem de programação, enfrentamos alguns desafios além do cumprimento dessas regras.
O arquivo files\run.ps1 será a referência das "linhas".

1- Linha 11: O jogo precisa ser iniciado com uma palavra.
O arquivo files\lista_palavras.txt contém 100 palavras comuns, de 5 letras. Ao iniciar o jogo, uma dessas palavras é escolhida aleatoriamente como ponto de partida.

2- Linha 12: As palavras precisam ser armazenadas.
O array $palavras se encarregará dessa função, sendo o responsável por validar se a palavra digitada já foi registrada.

3- Linha 64: O contador.
O contador foi um dos principais desafios, pois ele roda em paralelo ao código principal, logo não consegue enxergar as variáveis desse script. Então, foi necessário usar arquivos de texto (vazios mesmo) como variáveis, tanto no script principal, quanto no script do contador.

4- Linha 120: Verificar quantas letras possui a nova palavra:
A nova palavra precisa ter exatamente 5 letras, logo foi necessário fazer essa validação. Caso uma palavra com mais/menos de 5 letras fosse digitada, isso somaria um erro para o jogador.

5- Linha 125: Validar a palavra:
A palavra digitada precisa existir na língua portuguesa, para que não seja possível fazer pontos com uma palavra inventada. A maneira de fazer isso foi com um get num dicionário online + a palavra digitada. O dicionário utilizado (Priberam) retorna a string "Palavra não encontrada" quando uma palavra não é encontrada no dicionário, o que ajudou bastante na questão da validação;

6- Linha 140: Verificar quantas letras foram trocadas para formar a nova palavra.
Também foi uma das partes mais desafiadoras. Podem ser trocadas até duas letras para formar uma nova palavra. Esta validação vai comparar a diferença entre a palavra atual e a nova palavra para verificar quantas letras foram modificadas a fim de calcular os pontos (2 pontos por trocar apenas uma letra e 1 ponto por trocar duas letras) ou o erro, por tentar trocar mais de duas letras.

7- Linha 174: Recorde
Os pontos que você fez são comparados com pontos armazenados no arquivo files\recorde.txt. Caso sua pontuação seja maior do que a pontuação registrada, você receberá uma mensagem que atingiu um novo recorde! Para zerar o recorde, edite o arquivo de recorde e coloque um zero.

Observações gerais:
1- O script em questão contém bastantes ScriptBlocks, que lembram um pouco funções, porém não possuem parâmetros nem contexto.
Como o próprio nome sugere, ScriptBlocks são blocos de scripts armazenados numa variável, que podem ser usados a qualquer momento no código em vez de repetir as mesmas linhas várias vezes. Ex: 
$telaPrincipal = {
    cls
    Write-Host "Pontos: " -NoNewline; Write-Host $pontos -f Green
    Write-Host "Erros: " -NoNewline; Write-Host $erro/$limiteErros -f Green
    Write-Host "Palavra: " -NoNewline; Write-Host $($palavras[-1]) -f green
}

&$telaPrincipal

Uma vez definido o ScriptBlock $telaPrincipal, o código dentro dele pode ser chamado a qualquer momento por $telaPrincipal, tornando o código mais organizado, legível e prático.

2- Linha 23: As 3 primeiras condicionais do ScriptBlock $retornoResposta precisaram ter uma ordem bem específica.
Para evitar processamento desnecessário, foi preciso organizar as condicionais desse bloco conforme se encontram atualmente no script. Observe que não faria sentido verificar se uma palavra existe ou não na língua portugesa se ela sequer contém 5 letras, ou se ela já foi registrada.

Curti bastante o desafio de replicar essa brincadeira que fazíamos em casa para a programação, foi bem estimulante e pretendo fazer mais disso. Mas pretendo deixar este projeto sempre em aberto para quando eu tiver uma nova ideia continuar a complementa-lo. Sinta-se a vontade para baixar, testar, modificar, jogar e sugerir updates!
