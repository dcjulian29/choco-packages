$packageName = "btsync"
$installerType = "EXE"
$installerArgs = "/PERFORMINSTALL /AUTOMATION"
$url = "http://download.getsyncapp.com/endpoint/btsync/os/windows/track/stable"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    if (Get-Process -Name BTSync -ea 0) {
        Get-Process -Name BTSync | Stop-Process
    }

    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64 -validExitCodes 1

    if (Test-ProcessAdminRights) {
        Remove-Item "$($env:PUBLIC)\Desktop\BitTorrent Sync.lnk" -Force
    } else {
        Start-ChocolateyProcessAsAdmin "Remove-Item '$($env:PUBLIC)\Desktop\BitTorrent Sync.lnk' -Force"
    }

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
