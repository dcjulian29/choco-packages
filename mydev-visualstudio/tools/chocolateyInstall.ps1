$packageName = "mydev-visualstudio"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

$webpi = "$($env:ChocolateyInstall)\bin\webpicmd.bat"

& $webpi /Install /AcceptEula /SuppressReboot /Products:WebMatrixWeb
& $webpi /Install /AcceptEula /SuppressReboot /Products:WindowsAzurePowershell
& $webpi /Install /AcceptEula /SuppressReboot /Products:VWDOrVs2015AzurePack.2.8.1
