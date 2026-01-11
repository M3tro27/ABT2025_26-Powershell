for ($i = 0; $i -lt 10; $i++) {
    $number = Get-Random -Minimum 10 -Maximum 100
    $power = $number * $number
    "{0, -5} {1, -10}" -f $number, $power
}
