$packageName = "octopusdeploy-tentacle"
$installerType = "MSI"
$installerArgs = "/quiet"
$url = "http://download.octopusdeploy.com/octopus/Octopus.Tentacle.2.4.5.46.msi"
$url64 = "http://download.octopusdeploy.com/octopus/Octopus.Tentacle.2.4.5.46-x64.msi"


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
