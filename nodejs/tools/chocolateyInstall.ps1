$packageName = "nodejs"
$installerType = "MSI"
$installerArgs = "/qb"

$version = "6.2.1"
$rootUrl = "https://nodejs.org/dist/v$version"

$url = "$rootUrl/node-v$version-x86.msi"
$url64 = "$rootUrl/node-v$version-x64.msi"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64
