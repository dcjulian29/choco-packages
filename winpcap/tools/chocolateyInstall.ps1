$packageName = "winpcap" # arbitrary name for the package, used in messages
$url = "http://www.winpcap.org/install/bin/WinPcap_4_1_3.exe"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"
$downloadPath = "$env:TEMP\chocolatey\winpcap"
$installer = "$downloadPath\winpcapInstall.exe"
$ahkExe = "C:\tools\apps\autohotkey\AutoHotkey.exe"
$ahkScript = "$toolDir\install.ahk"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force | Out-Null
}

New-Item -ItemType directory $downloadPath -Force | Out-Null

Get-ChocolateyWebFile $packageName $installer $url

if (Test-ProcessAdminRights) {
    Invoke-Expression "$ahkExe $ahkScript"
} else {
    Start-ChocolateyProcessAsAdmin "$ahkExe $ahkScript" -noSleep
}
