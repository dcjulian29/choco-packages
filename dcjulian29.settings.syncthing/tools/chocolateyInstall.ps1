$location = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$key = Get-Item $location

if ($null -ne $key.GetValue("syncthing", $null)) {
  Remove-ItemProperty -Path $location -Name "syncthing" -Force
}

New-ItemProperty -Path $location -Name "syncthing" `
  -Value "$PSScriptRoot\start-syncthing.cmd"

Set-Content -Path "$PSScriptRoot\start-syncthing.cmd" -Value @"
@echo off

FOR /F "delims=" %%i IN ('dir "%ChocolateyInstall%\lib\syncthing\tools" /b /ad-h /t:c') DO (
  SET a=%%i
)

echo Starting Syncthing in %a%...

start /MIN %ChocolateyInstall%\lib\syncthing\tools\%a%\syncthing.exe --no-console --no-browser
"@

New-NetFirewallRule -DisplayName 'Syncthing-Inbound-TCP' -Direction Inbound `
  -Action Allow -Protocol TCP -LocalPort 22000

New-NetFirewallRule -DisplayName 'Syncthing-Inbound-UDP' -Direction Inbound `
  -Action Allow -Protocol UDP -LocalPort 22000
