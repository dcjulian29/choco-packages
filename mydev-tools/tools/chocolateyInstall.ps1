$packageName = "devvm-tools"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Write-Output "Installed package: $packageName"
