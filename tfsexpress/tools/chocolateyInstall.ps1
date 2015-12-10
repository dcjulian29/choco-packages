$packageName = "tfsexpress"
$installerType = "EXE"
$installerArgs = "/quiet"
$url = "http://download.microsoft.com/download/F/7/4/F7485C1E-3E67-4F1D-B2DB-20098E26D087/tfs_express.exe"

$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url

Start-ChocolateyProcessAsAdmin ". $toolDir\postInstall.ps1"
