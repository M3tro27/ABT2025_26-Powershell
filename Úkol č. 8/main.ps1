function GetApps-FromRegistry {
    $registry_list = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )

    $app_list = @()
    foreach ($path in $registry_list) {
        $app_list += ItemProperty -Path $path
    }
    $final_list = $app_list | Sort-Object DisplayName -Unique
    return $final_list |
            Where-Object { $_.DisplayName -ne $null } |
            Select-Object @{n="Name";e={$_.DisplayName}},
                          @{n="Version";e={$_.DisplayVersion}},
                          @{n="Source";e={"Registry"}}
}

function GetApps-FromWinget {
    $list = winget list
    $lines = $list -Split "`r`n" | Where-Object { $_ -Match "\S"}
    $header_index = $lines | Select-String "Name" | Select-Object -ExpandProperty LineNumber
    $header_line = $lines[$header_index-1]

    $id = $header_line.IndexOf("Id")
    $version = $header_line.IndexOf("Version")
    $available = $header_line.IndexOf("Available")
    $source = $header_line.IndexOf("Source")

    $final_list = foreach ($line in $lines[($header_index + 1) .. $lines.Count]) {
        [PSCustomObject]@{
            Name    = $line.Substring(0, $id).Trim()
            Version = $line.Substring($version, ($available - $version)).Trim()
            Source = "Winget"
        }
    }
    return $final_list
}

function GetApps-FromAppx {
    $final_list = Get-AppxPackage
    return $final_list |
            Where-Object { $_.Name -ne $null } |
            Select-Object @{n="Name";e={$_.Name}},
                          @{n="Version";e={$_.Version}},
                          @{n="Source";e={"AppX"}}
}

$complete_apps = @(
    GetApps-FromRegistry
    GetApps-FromWinget
    GetApps-FromAppx
) | Sort-Object Name, Version -Unique

$complete_apps | Sort-Object Name | Format-List