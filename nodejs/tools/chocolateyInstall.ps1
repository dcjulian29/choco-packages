$packageName = "nodejs"
$installerType = "MSI"
$installerArgs = "/qb"
$version = "0.12.7"
$url = "http://nodejs.org/dist/v$version/node-v$version-x86.msi"
$url64 = "http://nodejs.org/dist/v$version/x64/node-v$version-x64.msi"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64
