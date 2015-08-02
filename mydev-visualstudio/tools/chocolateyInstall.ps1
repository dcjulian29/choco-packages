$packageName = "mydev-visualstudio"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {

    $webpi = "$($env:ChocolateyInstall)\bin\webpicmd.bat"

    & $webpi /Install /AcceptEula /SuppressReboot /Products:WebMatrixWeb
    & $webpi /Install /AcceptEula /SuppressReboot /Products:WindowsAzurePowershell
    & $webpi /Install /AcceptEula /SuppressReboot /Products:VWDOrVs2015AzurePack.2.7

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
