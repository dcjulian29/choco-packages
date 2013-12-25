$packageName = "tightvnc"
$installerType = "MSI"
$installerArgs = "/quiet /norestart"
$url = "http://www.tightvnc.com/download/2.7.10/tightvnc-2.7.10-setup-32bit.msi"
$url64 = "http://www.tightvnc.com/download/2.7.10/tightvnc-2.7.10-setup-64bit.msi"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
