$packageName = "postman"
$installerType = "EXE"
$installerArgs = '--uninstall -s'
$path = "${env:LOCALAPPDATA}\Postman\Update.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Uninstall-ChocolateyPackage $packageName $installerType $installerArgs $path
