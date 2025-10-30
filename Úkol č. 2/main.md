## Zadání 1

``` Powershell
notepad $PROFILE
```

``` Microsoft.PowerShell_profile.ps1
$policy = Get-ExecutionPolicy
Write-Host "Execution Policy: $policy" -ForegroundColor Yellow
Write-Host "Profilová cesta: $PROFILE" -ForegroundColor Green
```

## Zadání 2
``` Powershell
Set-Alias np notepad.exe
Set-Alias ct control.exe

$aliases = Get-Alias np, ct | Select-Object Name, Definition
$aliases | ConvertTo-Json | Out-File aliases.json

Remove-Item Alias:np
Remove-Item Alias:ct

$aliases = Get-Content aliases.json | ConvertFrom-Json
foreach ($a in $aliases) {
    Set-Alias -Name $a.Name -Value $a.Definition
}


```