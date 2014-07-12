$packageName = "btsync"
$installerType = "EXE"
$installerArgs = "/PERFORMINSTALL /AUTOMATION"
$url = "http://download-lb.utorrent.com/endpoint/btsync/os/windows/track/stable"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url -validExitCodes 1

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
