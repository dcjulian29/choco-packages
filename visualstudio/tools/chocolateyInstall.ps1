$packageName = "visualstudio"
$installerType = "EXE"
$installerArgs = "/PASSIVE /NORESTART"
$url = "http://download.microsoft.com/download/D/B/D/DBDEE6BB-AF28-4C76-A5F8-710F610615F7/vs_premium.exe"
$update = "http://download.microsoft.com/download/8/2/6/826E264A-729E-414A-9E67-729923083310/VSU1/VS2013.1.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

try
{
    if (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\DevDiv\vs\Servicing\12.0")) {
        Install-ChocolateyPackage $packageName $installerType $installerArgs $url
    }
    
    Install-ChocolateyPackage $packageName $installerType $installerArgs $update
    
    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
