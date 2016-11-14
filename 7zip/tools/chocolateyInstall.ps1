$packageName = "7zip"
$installerType = "MSI"
$installerArgs = "/quiet"
$url = "http://www.7-zip.org/a/7z1604.exe"
$url64 = "http://www.7-zip.org/a/7z1604-x64.msi"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64

$cmd = "reg.exe import $toolDir\registry.reg"

if (Get-ProcessorBits -eq 64) {
    $cmd = "$cmd /reg:64"
}

if (Test-ProcessAdminRights) {
    Invoke-Expression $cmd
} else {
    Start-ChocolateyProcessAsAdmin "$cmd"
}
