$packageName = "chrome"
$installerType = "MSI"
$installerArgs = "/quiet"
$url = "https://dl.google.com/tag/s/appguid={8A69D345-D564-463C-AFF1-A69D9E530F96}&iid={00000000-0000-0000-0000-000000000000}&lang=en&browser=3&usagestats=0&appname=Google%2520Chrome&needsadmin=prefers/edgedl/chrome/install/GoogleChromeStandaloneEnterprise.msi"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

$app = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq "Google Chrome" }

if ($app) {
    Write-Output "Chrome is already installed and will update itself, no need to update via package..."
} else {
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64
    
    if (Test-ProcessAdminRights) {
        Remove-Item "$($env:PUBLIC)\Desktop\Google Chrome.lnk" -Force
    } else {
        Start-ChocolateyProcessAsAdmin "Remove-Item '$($env:PUBLIC)\Desktop\Google Chrome.lnk' -Force"
    }
}
