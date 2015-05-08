$packageName = "posh-azure"
$url = "https://github.com/Azure/azure-powershell/releases/download/0.9.1-May2015/azure-powershell.0.9.1.msi"
$installerType = "MSI"
$installerArgs = "/qb"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url
