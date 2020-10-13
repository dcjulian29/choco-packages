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

FOR /F "delims=" %%i IN ('dir "%ChocolateyInstall%\lib\syncthing\tools" /b /ad-h /t:c /o-d') DO (
SET a=%%i
)

echo Starting Syncthing in %a%...

start %a%\syncthing.exe -no-console -no-browser
"@
