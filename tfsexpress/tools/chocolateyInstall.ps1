$packageName = "tfsexpress"
$installerType = "EXE"
$installerArgs = "/quiet"
$url = "http://download.microsoft.com/download/C/A/F/CAF8D1B5-3065-4FEB-B9F0-3E6DAD0C03C8/tfs_express.exe"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url

Start-ChocolateyProcessAsAdmin ". $toolDir\postInstall.ps1"
