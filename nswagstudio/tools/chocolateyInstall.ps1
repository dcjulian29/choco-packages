$packageName = "nwagstudio"
$installerType = "MSI"
$installerArgs = "/quiet"

$url = "http://rsuter.com/Projects/NSwagStudio/installer.php"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url
