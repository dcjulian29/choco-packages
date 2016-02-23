$packageName = "chefdk"
$installerType = "MSI"
$installerArgs = '/passive'
$url = "https://opscode-omnibus-packages.s3.amazonaws.com/windows/2008r2/i386/chefdk-0.10.0-1-x86.msi"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url
