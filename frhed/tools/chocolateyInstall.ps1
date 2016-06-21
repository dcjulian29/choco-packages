$packageName = "frhed"
$installerType = "EXE"
$installerArgs = "/S"
$url = "https://sourceforge.net/projects/frhed/files/1.%20Stable%20Releases/1.6.0/Frhed-1.6.0-Setup.exe/download"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url
