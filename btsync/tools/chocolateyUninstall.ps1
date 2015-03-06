$packageName = "btsync"
$installerType = "exe"
$installerArgs = "/UNINSTALL"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    if (Test-Path "$env:ProgramFiles\BitTorrent Sync") {
        $cmd = "$env:ProgramFiles\BitTorrent Sync\BTSync.exe"
    }

    if (Test-Path "${env:ProgramFiles(x86)}\BitTorrent Sync") {
        $cmd = "${env:ProgramFiles(x86)}\\BitTorrent Sync\BTSync.exe"
    }

    Uninstall-ChocolateyPackage $packageName $installerType $installerArgs $cmd

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
