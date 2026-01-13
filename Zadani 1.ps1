function Confirm-Directory {
    param ([string]$Path)

    if (-not (Test-Path -Path $Path)) {
        New-Item -Path $Path -ItemType Directory -Force | Out-Null
    }
}

function Make-Screanshot {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $Screen = [System.Windows.Forms.Screen]::PrimaryScreen
    $Width = $Screen.Bounds.Width
    $Height = $Screen.Bounds.Height
    $Left = $Screen.Bounds.Left
    $Top = $Screen.Bounds.Top

    $Bitmap = New-Object System.Drawing.Bitmap -ArgumentList $Width, $Height
    $Graphic = [System.Drawing.Graphics]::FromImage($Bitmap)

    $Graphic.CopyFromScreen($Left, $Top, 0, 0, $Bitmap.Size)

    Confirm-Directory -Path "$HOME\Desktop\Screens"
    $FilePath = "$HOME\Desktop\Screens\Screenshot_$( Get-Date -Format 'dd-MM-yyyy-HH-mm-ss' ).png"
    $Bitmap.Save($FilePath, [System.Drawing.Imaging.ImageFormat]::Png)

    $Graphic.Dispose()
    $Bitmap.Dispose()
}

while($true) {
    Make-Screanshot
    Start-Sleep -Seconds 30
}