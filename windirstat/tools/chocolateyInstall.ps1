$packageName = "windirstat"
$installerType = "EXE"
$installerArgs = "/S"
$url = "https://julianscorner.com/downloads/windirstat1_1_2_setup.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url
