$packageName = "winpcap"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"
$ahkExe = "C:\tools\apps\autohotkey\AutoHotkey.exe"
$ahkScript = "$toolDir\uninstall.ahk"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Test-ProcessAdminRights) {
    Invoke-Expression "$ahkExe $ahkScript"
} else {
    Start-ChocolateyProcessAsAdmin "$ahkExe $ahkScript" -noSleep
}
