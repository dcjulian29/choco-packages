$packageName = "dotnet"
$installerType = "EXE"
$installerArgs = "/passive /norestart"
$url = "http://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
