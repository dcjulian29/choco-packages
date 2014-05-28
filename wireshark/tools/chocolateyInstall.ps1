$packageName = "wireshark"
$installerType = "EXE"
$installerArgs = "/S"
$url = "http://wiresharkdownloads.riverbed.com/wireshark/win32/Wireshark-win32-1.10.7.exe"
$url64 = "http://wiresharkdownloads.riverbed.com/wireshark/win64/Wireshark-win64-1.10.7.exe"

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
