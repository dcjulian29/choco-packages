$packageName = "octopusdeploy-server"
$installerType = "MSI"
$installerArgs = "/quiet"
$version = "2.5.8.447"
$url = "http://download.octopusdeploy.com/octopus/Octopus.$version.msi"
$url64 = "http://download.octopusdeploy.com/octopus/Octopus.$version-x64.msi"

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
