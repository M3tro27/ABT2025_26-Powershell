$URI = "https://www.gutenberg.org/cache/epub/1531/pg1531.txt"
$file_path = "$HOME\Desktop\Othello.txt"

if (-not (Test-Path $file_path)) {
    Write-Host "Fetching Othello..."
    Invoke-WebRequest -URI $URI -OutFile $file_path
}

$content = Get-Content -Path $file_path

$charCounts = $content.ToLower().ToCharArray() |
    Where-Object { $_ -match '[a-z]' } |
    Group-Object |
    Select-Object @{Name='Character'; Expression={$_.Name}}, Count |
    Sort-Object Count -Descending

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms.DataVisualization

$Chart = New-Object System.Windows.Forms.DataVisualization.Charting.Chart
$Chart.Width = 1000
$Chart.Height = 600
$Chart.BackColor = [System.Drawing.Color]::White

$Title = New-Object System.Windows.Forms.DataVisualization.Charting.Title
$Title.Text = "Četnost znaků ve hře Othello"
$Title.Font = New-Object System.Drawing.Font("Arial", 16, [System.Drawing.FontStyle]::Bold)
$Chart.Titles.Add($Title)

$ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
$ChartArea.AxisX.Title = "Znaky"
$ChartArea.AxisY.Title = "Počet výskytů"
$ChartArea.AxisX.Interval = 1
$Chart.ChartAreas.Add($ChartArea)

$Series = New-Object System.Windows.Forms.DataVisualization.Charting.Series
$Series.ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Column
$Series.Color = [System.Drawing.Color]::SteelBlue

foreach ($item in $charCounts) {
    $Series.Points.AddXY($item.Character, $item.Count)
}
$Chart.Series.Add($Series)

$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Analýza textu: Othello"
$Form.Width = 1024
$Form.Height = 650
$Form.StartPosition = "CenterScreen"
$Form.Controls.Add($Chart)

Write-Host "`nStatistika četnosti znaků:" -ForegroundColor Yellow
$charCounts | Format-Table -AutoSize

Write-Host "Otevírám okno s grafem..." -ForegroundColor Green
$Form.ShowDialog()