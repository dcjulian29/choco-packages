$packageName = "grepwin"
$installerType = "MSI"
$installerArgs = "/quiet"
$url = "https://sourceforge.net/projects/grepwin/files/1.6.13/grepWin-1.6.13.msi/download"
$url64 = "https://sourceforge.net/projects/grepwin/files/1.6.13/grepWin-1.6.13-x64.msi/download"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64
