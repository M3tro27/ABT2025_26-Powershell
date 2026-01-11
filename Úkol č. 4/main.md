# Úkol č. 4

## Zadání 1

``` PowerShell
$numlock = (Get-ItemProperty -Path "Registry::HKEY_Users\.DEFAULT\Control Panel\Keyboard").InitialKeyboardIndicators
$numlock
if ($numlock -ne 2) {
    Set-ItemProperty -Path "Registry::HKEY_Users\.DEFAULT\Control Panel\Keyboard" -Name InitialKeyboardIndicators -Value 2
}
```

# Zadání 2

``` PowerShell
New-Item -Path "HKCU:\Software" -Name "HratkySPowerShellem"
$path = "HKCU:\Software\HratkySPowerShellem"

New-ItemProperty -Path $path -Name "AccountName" -Value $env:UserName -PropertyType String
New-ItemProperty -Path $path -Name "ComputerName" -Value $env:ComputerName -PropertyType String
New-ItemProperty -Path $path -Name "CurrentDate" -Value (Get-Date)
New-ItemProperty -Path $path -Name "PSVersion" -Value $PSVersionTable.PSVersion.ToString() -PropertyType String
```