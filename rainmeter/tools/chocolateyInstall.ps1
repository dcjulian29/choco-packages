$packageName = "rainmeter"
$installerType = "EXE"
$installerArgs = "/S /STARTUP=1 /ALLUSERS=1"
$url = "https://github.com/rainmeter/rainmeter/releases/download/v3.1.0.2190/Rainmeter-3.1.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
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
