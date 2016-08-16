$packageName = "grepwin"
$installerType = "MSI"
$installerArgs = "/quiet"
$url = "https://julianscorner.com/downloads/grepWin-1.6.14.msi"
$url64 = "https://julianscorner.com/downloads/grepWin-1.6.14-x64.msi"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64
