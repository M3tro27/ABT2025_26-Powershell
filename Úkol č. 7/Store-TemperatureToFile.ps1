function Get-Temperature {
    $URI = "https://wttr.in/Brno?format=%t"
    $response = Invoke-WebRequest -URI $URI
    $temperature = $response.Content
    return $temperature
}

function Store-TemperatureToFile {
    $path = "~\Desktop\teploty.txt"
    $temperature = Get-Temperature
    $temperature = "`n" + $temperature
    Add-Content -Path $path -Value $temperature
}

Store-TemperatureToFile