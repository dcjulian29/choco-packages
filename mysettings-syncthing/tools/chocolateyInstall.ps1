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

start %ChocolateyInstall%\lib\syncthing\tools\%a%\syncthing.exe -no-console -no-browser
"@

New-NetFirewallRule -DisplayName 'Syncthing-Inbound-TCP' -Profile Domain -Direction Inbound `
    -Action Allow -Protocol TCP -LocalPort 22000
New-NetFirewallRule -DisplayName 'Syncthing-Inbound-UDP' -Profile Domain -Direction Inbound `
    -Action Allow -Protocol UDP -LocalPort 22000
