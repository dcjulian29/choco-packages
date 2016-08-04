$packageName = "frhed"
$installerType = "EXE"
$installerArgs = "/S"
$url = "https://julianscorner.com/downloads/Frhed-1.6.0-Setup.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url
