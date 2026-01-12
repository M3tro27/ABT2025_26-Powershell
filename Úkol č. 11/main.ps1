$running = $true
function Get-WordsOnWebPage
{
    function Parse-WebPage
    {
        param([string]$URI, [int]$length)
        try {
            $response = Invoke-WebRequest -URI $URI
            $content = $response.Content
            $regex = "\s[a-záčďéěíňóřšťúůýžA-ZÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ]{$length}\s"

            $results = ($content | Select-String -Pattern $regex -AllMatches).Matches.Value
            return $results.Trim().ToLower() | Sort-Object -Unique
        } catch {
            Write-Host "Nelze provést scrape URI... Zkontrolujte syntax a připojení k internetu" -BackgroundColor Red
        }
    }

    while ($running)
    {
        $URI = Read-Host "Zadejte URI: "
        switch ($URI.ToLower())
        {
            'q' {
                $running = $false
            }
            '' {
                Write-Host "--------------------------------------------------------------------------------------"
                Write-Host "[URI] Pro pokračování zadejte URI ve formátu 'https://example.net/something/new'"
                Write-Host "[Q] Exit"
                Write-Host "--------------------------------------------------------------------------------------"
            }
            default {

                $length = Read-Host "Zadejte délku slova: "
                switch ($length)
                {
                    'q' {
                        $running = $false
                    }
                    '' {
                        Write-Host "--------------------------------------------"
                        Write-Host "[Délka] Pro pokračování zadejte délku slova"
                        Write-Host "[Q] Exit"
                        Write-Host "--------------------------------------------"
                    }
                    default {
                        $number = 0
                        if ([int]::TryParse($length, [ref]$number)) {
                            Parse-WebPage -URI $URI -Length $length
                        } else {
                            Write-Host "Špatně zadaný vstup... Délka musí být číslo!" -BackgroundColor Red
                        }
                    }
                }
            }
        }
    }
    Write-Host "------------------------------------"
    Write-Host "Neplecha ukončena"
}

Get-WordsOnWebPage