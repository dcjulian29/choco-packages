$packageName = "winpcap"
$ahkExe = "C:\tools\apps\autohotkey\AutoHotkey.exe"
$ahkScript = "$PSScriptRoot\uninstall.ahk"

Invoke-ElevatedCommand -File $ahkExe -ArgumentList $ahkScript -Wait
