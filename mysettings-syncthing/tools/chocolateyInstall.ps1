$packageName = "mysettings-syncthing"

$location = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"

$key = Get-Item $location

if ($key.GetValue($packageName, $null) -ne $null) {
    Remove-ItemProperty -Path $location -Name $packageName
}

New-ItemProperty -Path $location -Name "syncthing" `
    -Value "$env:SYSTEMDRIVE\Tools\start-syncthing.cmd"

Set-Content -Path "$env:SYSTEMDRIVE\Tools\start-syncthing.cmd" -Value @"
@echo off

echo Starting Syncthing...
start $env:ChocolateyInstall\bin\syncthing.exe -no-console -no-browser
"@
