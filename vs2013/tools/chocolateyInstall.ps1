$packageName = "vs2013"
$installerType = "EXE"
$installerArgs = "/PASSIVE /NORESTART"
$url = "http://download.microsoft.com/download/D/B/D/DBDEE6BB-AF28-4C76-A5F8-710F610615F7/vs_premium.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
