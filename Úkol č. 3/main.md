# Úkol č. 3

## Prompt

K vygenerování skriptů jsem využíval **ChatGPT-5** verzi zdarma.

``` GenAI prompt
Jsi zkušený PowerShell expert s mnohaletou praxí v systémové administraci na platformách Windows.
Tvým úkolem je vytvořit co nejjednodušší, přehledné a plně funkční PowerShell skripty pro PowerShell verze 7.5.4.
Pokud není uvedeno jinak, využívej rozhraní CIM (Common Information Model) namísto WMI či starších cmdletů.
Vždy dodržuj best practices.

Všechny skripty musí:
Být plně funkční a testovatelné na Windows 10/11 nebo Windows Server 2022,
Obsahovat pouze nezbytný kód (žádné zbytečné komplikace a komentáře),
Respektovat zásady čitelnosti a správné syntaxe PowerShellu 7.x.

Úkoly:
1. Správa tiskáren:
Zjisti vlastnosti třídy, která umožňuje spravovat tiskárny (pomocí CIM).
Změň umístění tiskárny Fax na nové (např. "Kancelář").

2. Přejmenování disku:
Zjisti aktuální název disku C:.
Přejmenuj jej na "Systém".

3. Správa uživatelských účtů:
Pomocí vhodných cmdletů vypiš seznam:
a) účtů, ke kterým se nikdo nikdy nepřihlásil,
b) účtů, které jsou uzamčené.
Poté vytvoř alternativní řešení stejného úkolu pomocí rozhraní CIM.

Formát výstupu:
Pro každý úkol:
Uveď nadpis (### Úkol 1, ### Úkol 2 atd.),
Přidej stručný komentář vysvětlující, co skript dělá,
Uveď kompletní PowerShell skript, připravený k použití,
```

---

## Zadání 1

``` PowerShell
# Zobrazení vlastností třídy pro správu tiskáren
Get-CimClass -ClassName Win32_Printer | Select-Object -ExpandProperty CimClassProperties

# Změna umístění tiskárny Fax
$printer = Get-CimInstance -ClassName Win32_Printer -Filter "Name='Fax'"
Set-CimInstance -InputObject $printer -Property @{ Location = "Kancelář" }
```

## Zadání 2

``` PowerShell
# Zjištění aktuálního názvu disku C:
Get-CimInstance -ClassName Win32_Volume -Filter "DriveLetter='C:'" | Select-Object DriveLetter, Label

# Přejmenování disku C: na "Systém"
Set-CimInstance -Query "SELECT * FROM Win32_Volume WHERE DriveLetter='C:'" -Property @{ Label = "Systém" }
```


## Zadání 3

### Pomocí cmdletů

``` PowerShell
# Účty, ke kterým se nikdo nikdy nepřihlásil
Get-LocalUser | Where-Object { -not $_.LastLogon } | Select-Object Name, Enabled, LastLogon

# Účty, které jsou uzamčené
Get-LocalUser | Where-Object { $_.LockedOut } | Select-Object Name, Enabled, LockedOut
```

### Pomocí CIM

``` PowerShell
# Účty, ke kterým se nikdo nikdy nepřihlásil
Get-CimInstance -ClassName Win32_UserAccount |
    Where-Object { -not $_.LastLogon } |
    Select-Object Name, Disabled, Lockout, LastLogon

# Účty, které jsou uzamčené
Get-CimInstance -ClassName Win32_UserAccount |
    Where-Object { $_.Lockout -eq $true } |
    Select-Object Name, Disabled, Lockout
```