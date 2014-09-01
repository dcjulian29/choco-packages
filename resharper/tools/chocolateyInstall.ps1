$packageName = "resharper"
$installerType = "MSI"
$installerArgs = "/qb"
$url = "http://download-cf.jetbrains.com/resharper/ReSharperSetup.8.2.1000.4556.msi"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
