$packageName = "wireshark"
$installerType = "EXE"
$installerArgs = "/S"
$url = "https://2.na.dl.wireshark.org/win32/Wireshark-win32-1.10.6.exe"
$url64 = "https://2.na.dl.wireshark.org/win64/Wireshark-win64-1.10.6.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
