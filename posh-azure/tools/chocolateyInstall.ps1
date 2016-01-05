$packageName = "posh-azure"
$url = "https://github.com/Azure/azure-powershell/releases/download/v1.0.1-November2015/azure-powershell.1.0.1.msi"
$installerType = "MSI"
$installerArgs = "/qb"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url
