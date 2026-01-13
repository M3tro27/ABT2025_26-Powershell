# Nastavení cest k souborům
$basePath = "G:\Škola\ABT2025_26-Powershell"
$files = @("security1.evtx", "security2.evtx")

$celkovyPocet = 0

foreach ($file in $files) {
    $fullPath = Join-Path -Path $basePath -ChildPath $file
    
    if (Test-Path $fullPath) {
        Write-Host "--- Zpracovávám soubor: $file ---" -ForegroundColor Cyan
        
        # 1. Načtení událostí
        # Načteme všechny události, abychom je mohli filtrovat
        try {
            $events = Get-WinEvent -Path $fullPath -ErrorAction Stop
        }
        catch {
            Write-Warning "Nepodařilo se načíst soubor $file. Chyba: $_"
            continue
        }

        # 2. Filtrace "skutečných uživatelů"
        # Logika: 
        # - Musí mít UserId (SID)
        # - Vyloučíme systémové účty (SYSTEM, NETWORK SERVICE, LOCAL SERVICE - ty mají krátké SID nebo známá jména)
        # - Vyloučíme účty počítačů (končí znakem $)
        
        $filteredEvents = $events | Where-Object {
            $sid = $_.UserId
            
            # Pokud událost nemá přiřazeného uživatele, přeskočíme
            if ($null -eq $sid) { return $false }
            
            # Pokusíme se přeložit SID na jméno účtu pro přesnější filtraci
            # Pokud překlad selže (běžné u offline logů z cizích PC), použijeme samotné SID
            try {
                $account = $sid.Translate([System.Security.Principal.NTAccount]).Value
            } catch {
                $account = $sid.Value
            }

            # PODMÍNKY FILTRU:
            # 1. Nechceme systémové účty (SYSTEM, SERVICE, ANONYMOUS)
            # 2. Nechceme strojové účty (jméná končící na $)
            $isSystemOrMachine = ($account -match "AUTHORITY|SYSTEM|SERVICE|ANONYMOUS" -or $account -like "*$")
            
            # Vracíme True, pokud to NENÍ systém ani stroj
            return -not $isSystemOrMachine
        }

        # 3. Setřídění vzestupně podle času (pro každý soubor zvlášť)
        $sortedEvents = $filteredEvents | Sort-Object TimeCreated

        # 4. Zobrazení výsledku pro aktuální soubor
        # Zobrazíme Čas, ID události a Uživatele (formátujeme tabulku)
        $sortedEvents | Select-Object TimeCreated, Id, @{N='User';E={$_.UserId.Translate([System.Security.Principal.NTAccount]).Value}} | Format-Table -AutoSize

        # Přičtení k celkovému počtu
        $count = $sortedEvents.Count
        Write-Host "Počet relevantních událostí v $file : $count" -ForegroundColor Green
        $celkovyPocet += $count
        
        Write-Host "" # Prázdný řádek pro přehlednost
    }
    else {
        Write-Warning "Soubor $fullPath nebyl nalezen."
    }
}

Write-Host "------------------------------------------------"
Write-Host "Celkový počet událostí skutečných uživatelů: $celkovyPocet" -ForegroundColor Yellow