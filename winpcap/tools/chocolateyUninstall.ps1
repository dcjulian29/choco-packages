$packageName = "winpcap"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    if (Test-Path "$env:ChocolateyInstall\apps\autohotkey\AutoHotkey.exe") {
        $ahkExe = "$env:ChocolateyInstall\apps\autohotkey\AutoHotkey.exe"
        $ahkScript = "$toolDir\uninstall.ahk"

        if (Test-ProcessAdminRights) {
            Invoke-Expression "$ahkExe $ahkScript"
        } else {
            Start-ChocolateyProcessAsAdmin "$ahkExe $ahkScript" -noSleep
        }
    }

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
