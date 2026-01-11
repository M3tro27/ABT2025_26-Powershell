$Action = @{
    Execute  = 'powershell.exe'
    Argument = "-ExecutionPolicy Bypass -NoProfile -File 'G:\Škola\ABT2025_26-Powershell\Úkol č. 7\Store-TemperatureToFile.ps1'"
}

$Trigger = @{
    Daily = $true
    At    = '00:00:00'
    RepetitionInterval = (New-TimeSpan -Hours 1)
}

$registerTask = @{
    TaskName    = 'Store-TemperatureToFile'
    Action      = New-ScheduledTaskAction @Action
    Trigger     = New-ScheduledTaskTrigger @Trigger
    RunLevel    = 'Limited'
    Description = 'Spousti PS funkci na ulozeni teploty v Brne kazdou hodinu'
}

Register-ScheduledTask @registerTask