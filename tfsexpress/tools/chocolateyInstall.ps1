$packageName = "tfsexpress"
$installerType = "EXE"
$installerArgs = "/quiet"
$url = "http://download.microsoft.com/download/1/D/4/1D4802FE-5971-4A27-8E42-87EE5ACE8777/tfs_express.exe"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url

    Start-ChocolateyProcessAsAdmin ". $toolDir\postInstall.ps1"

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
