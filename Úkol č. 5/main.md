# Úkol č. 5

``` PowerShell
function file_browser {
    $running = $true
    while ($running) {
        Clear-Host

        $current_path = Get-Location
        $files = Get-ChildItem -Path $current_path.Path -File
        Write-Host "Aktuílní cesta: " ($current_path)

        if ($files.Count -gt 0) {
            Write-Host "Počet souborů: " ($files.Count)
            $smallest = ($files | Sort-Object Length)[0]
            $largest = ($files | Sort-Object Length)[-1]

            Write-Host "Nejmenší soubor: " $smallest.Name $smallest.Length
            Write-Host "Největší soubor: " $largest.Name $largest.Length

        }
        else {
            Write-Host "Nenalezeny žádné soubory"
        }

        Write-Host "---------------------------------"
        $directories =Get-ChildItem -Path $current_path -Directory
        $i = 0
        $directories | ForEach-Object { "[{0}]  {1}" -f $i++, $_.Name }

        Write-Host "---------------------------------"
        Write-Host "[U] Posunout o úroveň výš"
        Write-Host "[Q] Exit"
        Write-Host "---------------------------------"

        $user_choice = Read-Host "Zvolte možnost"
        switch ($user_choice.ToLower()) {
            'q' {
                $running = $false
            }
            'u' {
                Set-Location ..
            }
            default {
                $index = $user_choice -as [int]

                if ($null -ne $index -and $index -lt $directories.Count) {
                    Set-Location $directories[$index].Name
                } else {
                    Write-Host "Invalid selection!" -ForegroundColor Red
                }
            }
        }

    }

    Write-Host "Neplecha ukončena"

}

file_browser
```