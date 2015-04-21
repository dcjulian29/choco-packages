$packageName = "mysettings-vsix"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Write-Output "Visual Studio VSIX Virtual Package."
