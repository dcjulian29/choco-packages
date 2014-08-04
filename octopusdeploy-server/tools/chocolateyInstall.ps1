$packageName = "octopusdeploy-server"
$installerType = "MSI"
$installerArgs = "/quiet"
$url = "http://download.octopusdeploy.com/octopus/Octopus.2.5.5.318.msi"
$url64 = "http://download.octopusdeploy.com/octopus/Octopus.2.5.5.318-x64.msi"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
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
