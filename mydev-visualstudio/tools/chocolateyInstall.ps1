$packageName = "mydev-visualstudio"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    cinst -source webpi WebMatrixWeb
    cinst -source webpi WindowsAzureXPlatCLI
    cinst -source webpi WindowsAzurePowershell
    cinst -source webpi VWDOrVs2013AzurePack.2.4

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
