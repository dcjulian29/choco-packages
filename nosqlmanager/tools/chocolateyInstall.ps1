$packageName = "nosqlmanager"
$installerType = "EXE"
$installerArgs = "/SILENT /NORESTART"
$url = "http://www.mongodbmanager.com/files/mongodbmanagerpro_inst.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url
