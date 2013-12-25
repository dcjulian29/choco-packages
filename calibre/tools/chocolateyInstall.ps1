$packageName = "calibre"
$installerType = "MSI"
$installerArgs = "/quiet"
$url = "http://download.calibre-ebook.com/1.15.0/calibre-64bit-1.15.0.msi"
$url64 = "http://download.calibre-ebook.com/1.15.0/calibre-64bit-1.15.0.msi"

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
