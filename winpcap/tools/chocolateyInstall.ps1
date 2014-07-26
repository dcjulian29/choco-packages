$packageName = "winpcap" # arbitrary name for the package, used in messages
$url = "http://www.winpcap.org/install/bin/WinPcap_4_1_3.exe"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"
$downloadPath = "$env:TEMP\chocolatey\winpcap"
$installer = "$downloadPath\winpcapInstall.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    if (!(Test-Path $downloadPath)) {
        New-Item -ItemType directory $downloadPath -Force | Out-Null

    Get-ChocolateyWebFile $packageName $installer $url

    if (Test-Path "$env:ChocolateyInstall\apps\autohotkey\AutoHotkey.exe") {
        $ahkExe = "$env:ChocolateyInstall\apps\autohotkey\AutoHotkey.exe"
        $ahkScript = "$toolDir\install.ahk"

        Start-ChocolateyProcessAsAdmin "$ahkExe $ahkScript" -noSleep
    }

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
