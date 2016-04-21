$packageName = "azuresdk"
$webpi = "$($env:ChocolateyInstall)\bin\webpicmd.bat"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

& $webpi /Install /AcceptEula /SuppressReboot /Products:VWDOrVs2015AzurePack.2.9
