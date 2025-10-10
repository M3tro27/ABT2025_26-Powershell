## Zadání 1

``` Powershell
get-winevent -filterhashtable @{
    logname = "System"
    starttime = (get-date).adddays(-10)
    Level = 2
}
```

## Zadání 2
``` Powershell
$s = "506f7765727368656c6c20697320617765736f6d6521"
$bytes = for ($i = 0; $i -lt $s.Length; $i += 2) { [Convert]::ToByte($s.Substring($i, 2), 16) }
[System.Text.Encoding]::ASCII.GetString($bytes)
```