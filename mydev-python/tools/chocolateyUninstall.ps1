$packageName = "mydev-python"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Test-ProcessAdminRights) {
    . $toolDir\postUninstall.ps1
} else {
    Start-ChocolateyProcessAsAdmin ". $toolDir\postUninstall.ps1"
}
