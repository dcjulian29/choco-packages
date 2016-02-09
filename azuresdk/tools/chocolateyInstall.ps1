$packageName = "azuresdk"
$webpi = "$($env:ChocolateyInstall)\bin\webpicmd.bat"
$version = "2.8.1"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

& $webpi /Install /AcceptEula /SuppressReboot /Products:VWDOrVs2015AzurePack.$version
