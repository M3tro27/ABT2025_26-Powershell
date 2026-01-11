function Check-Palindrome {
    param( [int]$number )
    $is_palindrome = $true
    $string = $number.ToString()
    for ($i = 0; $i -lt $string.Length / 2; $i++) {
        if ($string[$i] -ne $string[-$i -1]) {
            $is_palindrome = $false
            break
        }
    }
    return $is_palindrome
}

$nejmensi = @()
$nejvetsi = @()

for ($x = 100; $x -lt 1000; $x++) {
    for ($y = 100; $y -lt 1000; $y++) {
        $number = $x * $y
        if (Check-Palindrome -Number $number) {
            Write-Host "Palindrome found: $number"
            if ($nejmensi.Count -eq 0 -and $nejvetsi.Count -eq 0) {
                $nejmensi = @($number, $x, $y)
                $nejvetsi = @($number, $x, $y)
            } else {
                if ($number -lt $nejmensi[0]) {
                    $nejmensi = @($number, $x, $y)
                } elseif ($number -gt $nejvetsi[0]) {
                    $nejvetsi = @($number, $x, $y)
                }
            }
        }
    }
}
Write-Host "Nejmensi palindrom: $nejmensi"
Write-Host "Nejvetsi palindrom: $nejvetsi"
