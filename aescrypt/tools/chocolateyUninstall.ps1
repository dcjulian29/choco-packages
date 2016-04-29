$packageName = "aescrypt"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if (Test-Path $appDir)
{
    Remove-Item "$($appDir)" -Recurse -Force
}

if (Test-ProcessAdminRights) {
    . $toolDir\postUninstall.ps1
} else {
    Start-ChocolateyProcessAsAdmin ". $toolDir\postUninstall.ps1"
}
