$location = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"

$key = Get-Item $location

if ($null -ne $key.GetValue("Executor", $null)) {
    Remove-ItemProperty -Path $location -Name "Executor"
}

New-ItemProperty -Path $location -Name Executor `
    -Value "$PSScriptRoot\executor-run.cmd" | Out-Null

Start-Process -FilePath $PSScriptRoot\executor-run.cmd -NoNewWindow
