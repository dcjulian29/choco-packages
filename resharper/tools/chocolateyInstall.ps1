$packageName = "resharper"
$installerType = "MSI"
$installerArgs = "/quiet /passive"
$url = "http://download.jetbrains.com/resharper/ReSharperSetup.8.2.3000.5176.msi"

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
