$packageName = "truecrypt"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

try
{
    if (Test-Path "$env:ChocolateyInstall\apps\autohotkey\AutoHotkey.exe") {
        $ahkExe = "$env:ChocolateyInstall\apps\autohotkey\AutoHotkey.exe"
        $ahkScript = "$toolDir\uninstall.ahk"

        Start-ChocolateyProcessAsAdmin "$ahkExe $ahkScript" -noSleep
    }

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
