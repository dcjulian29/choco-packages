$packageName = "mydev-visualstudio"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {

    $webpi = "$($env:ChocolateyInstall)\bin\webpicmd.bat"

    & $webpi /Install /AcceptEula /SuppressReboot /Products:WebMatrixWeb
    & $webpi /Install /AcceptEula /SuppressReboot /Products:WindowsAzureXPlatCLI
    & $webpi /Install /AcceptEula /SuppressReboot /Products:WindowsAzurePowershell
    & $webpi /Install /AcceptEula /SuppressReboot /Products:VWDOrVs2013AzurePack.2.5

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
