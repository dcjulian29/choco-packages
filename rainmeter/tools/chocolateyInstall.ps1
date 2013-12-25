$packageName = "rainmeter"
$installerType = "EXE"
$installerArgs = "/S /STARTUP=1 /ALLUSERS=1"
$url = "https://rainmeter.googlecode.com/files/Rainmeter-3.0.2.exe"

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
