# One-time package rename
if (Test-Path "../../executor-julian") {
    Remove-Item -Path "../../executor-julian" -Recurse -Force
}

$location = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"

$key = Get-Item $location

if ($null -ne $key.GetValue("Executor", $null)) {
    Remove-ItemProperty -Path $location -Name "Executor"
}

New-ItemProperty -Path $location -Name Executor `
    -Value "$PSScriptRoot\executor-run.cmd" | Out-Null

if (-not (Test-Path "${env:USERPROFILE}\.uwp")) {
    New-Item -Path "${env:USERPROFILE}\.uwp" -ItemType Directory | Out-Null
}

if (-not (Test-Path "${env:USERPROFILE}\.url")) {
    New-Item -Path "${env:USERPROFILE}\.url" -ItemType Directory | Out-Null
}
