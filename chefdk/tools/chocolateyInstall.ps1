$packageName = "chefdk"
$installerType = "MSI"
$installerArgs = '/passive'
$url = "https://packages.chef.io/stable/windows/2012r2/chefdk-0.16.28-1-x86.msi"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url
