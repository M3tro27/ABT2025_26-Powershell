function Check-Password {
    param( [string]$clipboard )
    $wordlist = @("password", "heslo", "psswd", "login", "token")
    foreach ($word in $wordlist) {
        if ($clipboard.ToLower() -like "*$word*") {
            Write-Host "Password detected: $clipboard" -BackgroundColor Red -ForegroundColor Black
            break
        }
    }
}

$temp = ""
while($true){
    $clipboard = Get-Clipboard
    if ($clipboard -ne $temp) {
        $temp = $clipboard
        Check-Password -Clipboard $clipboard
    }
    Start-Sleep -Seconds 5
}

# Zkusil jsem Brave password manager - Sniffer fungoval