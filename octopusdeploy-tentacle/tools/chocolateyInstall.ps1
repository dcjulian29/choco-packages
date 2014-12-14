$packageName = "octopusdeploy-tentacle"
$installerType = "MSI"
$installerArgs = "/quiet"
$version = "2.6.0.751"
$url = "http://download.octopusdeploy.com/octopus/Octopus.Tentacle.$version.msi"
$url64 = "http://download.octopusdeploy.com/octopus/Octopus.Tentacle.$version-x64.msi"

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
