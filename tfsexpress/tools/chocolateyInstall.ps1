$packageName = "tfsexpress"
$installerType = "EXE"
$installerArgs = "/quiet"
$url = "http://download.microsoft.com/download/7/7/D/77D9E159-4CAF-4F25-A7CF-8184505A2C0D/tfs_express.exe"
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
