cls
mode 100,20

#CONFIGURAÇÃO INICIAL
$ProgressPreference = 'SilentlyContinue'
$erro = 0
$pontos = 0
$checkLetrasPalavraDigitada = 4
$limiteErros = 3
$tempo = 30
$lista  = Get-Content $PSScriptRoot\lista_palavras.txt | Get-Random
$palavras = @($lista)

#TELA PRINCIAPL
$telaPrincipal = {
    cls
    Write-Host "Pontos: " -NoNewline; Write-Host $pontos -f Green
    Write-Host "Erros: " -NoNewline; Write-Host $erro/$limiteErros -f Green
    Write-Host "Palavra: " -NoNewline; Write-Host $($palavras[-1]) -f green
}

#RETORNO DA RESPOSTA
$retornoResposta = {
    $count = 5
    while ($count -ne 0){
        &$telaPrincipal
        ""
        Write-Host Nova palavra: $palavra
        ""

        if ($palavras -contains $palavra -and !$novaPalavra){
            Write-Host """$palavra"" já foi registrada" -b Red
        }

        elseif ($palavra.Length -ne 5){
            Write-Host """$palavra"" não contém 5 letras." -b Red
        }

        elseif ($check.RawContent -match 'Palavra não encontrada'){
            Write-Host """$palavra"" não existe ou não é uma palavra válida" -b Red
        }

        elseif ($mudanca -eq 1 -and $novaPalavra){
            Write-Host "Excelente! +2 pontos!!!" -f Green
        }

        elseif ($mudanca -eq 2 -and $novaPalavra){
            Write-Host "Muito bom! +1 ponto!" -f Green
        }  

        elseif ($mudanca -lt 1 -or $mudanca -gt 2){
             Write-Host "Altere no máximo até duas letras" -b Red
        }

        Write-Host "Próxima rodada em $count"
        sleep 1
        $count--
    }

    continue
}

#CONTADOR
$sbContador = {
    mode 40,5
    while($true){
        del .\palavra.txt -ErrorAction SilentlyContinue
        del .\timeout.txt -ErrorAction SilentlyContinue
        if (dir .\digitar.txt -ErrorAction SilentlyContinue){
            $tempo = 30
            while ($tempo -ne 0){
                sleep 1
                cls
                $tempo--
                $tempo
                $check = dir .\palavra.txt -ErrorAction SilentlyContinue
                if ($check){
                    del .\digitar.txt
                    cls
                    break
                }
            }

            if ($tempo -eq 0){
                '0' > .\timeout.txt
                ""
                Write-Host Tempo esgotado! GAME OVER. -b Red
                Read-Host
                break
            }

            $tempo = 30
        }
    }
}

$contador = Start-Process powershell -ArgumentList $sbContador -PassThru -WorkingDirectory $PSScriptRoot

#INICIO DO JOGO
while ($erro -lt $limiteErros){
    &$telaPrincipal
    '0' > $PSScriptRoot\digitar.txt
    
    ""
    $palavra = Read-Host Nova palavra
    $palavra > $PSScriptRoot\palavra.txt

    if (dir $PSScriptRoot\timeout.txt -ErrorAction SilentlyContinue){
        $erro = $limiteErros
        continue
    }

    $palavra = Get-Content $PSScriptRoot\palavra.txt
    if ($palavras -contains $palavra){
        $erro++
        $novaPalavra = 0
        &$retornoResposta  
    }

    if ($palavra.Length -ne 5){
        $erro++
        &$retornoResposta
    }

    try{
        $check = iwr "https://dicionario.priberam.org/$palavra" -UseBasicParsing -ErrorAction SilentlyContinue
    }catch{}

    if ($check.RawContent -match 'Palavra não encontrada'){
        $erro++
        &$retornoResposta
    }else{
        $sucesso = $true
    }

    if ($sucesso){
        $count = 0
        $mudanca = 0

        while($count -le $checkLetrasPalavraDigitada){
            if ($palavras[-1][$count] -ne $palavra[$count]){
                $mudanca++
            }
            $count++
        }
    
        if ($mudanca -eq 1){
            $pontos += 2
            $palavras += $palavra
            $novaPalavra = 1
            &$retornoResposta
        }

        if ($mudanca -eq 2){
            $pontos += 1
            $palavras += $palavra
            $novaPalavra = 1
            &$retornoResposta            
        }

        if ($mudanca -gt 2){
            $erro++
            &$retornoResposta
        }

        $sucesso = $false
    }
}


cls
Write-Host "Você atingiu o limite de erros. GAME OVER!" -f Yellow
""
$recorde = Get-Content $PSScriptRoot\recorde.txt

Write-Host "PONTUAÇÃO: " -NoNewline; Write-Host $pontos -f Green
if ($pontos -gt [int]$recorde){
    Write-Host NOVO RECORDE!!! -f Green
    $pontos > $PSScriptRoot\recorde.txt
}else{
    Write-Host "Recorde: " -NoNewline; Write-Host $recorde -f Yellow
}

Read-host