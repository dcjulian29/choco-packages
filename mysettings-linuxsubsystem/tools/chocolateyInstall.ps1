if (-not (Get-WindowsOptionalFeature -online | ? { $_.FeatureName -eq 'Microsoft-Windows-Subsystem-Linux' }).State) {
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
}

Set-Location -Path $env:TEMP

Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile Ubuntu.appx -UseBasicParsing

Rename-Item Ubuntu.appx Ubuntu.zip

if (Test-Path $env:SYSTEMDRIVE\Ubuntu) {
    Remove-Item -Path $env:SYSTEMDRIVE\Ubuntu -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $env:SYSTEMDRIVE\Ubuntu | Out-Null

Expand-Archive Ubuntu.zip $env:SYSTEMDRIVE\Ubuntu

Write-Information "You must reboot before using Linux Subsystem..."
