$packageName = "bingdesktop"
$installerType = "EXE"
$installerArgs = "/Q"
$url = "http://download.microsoft.com/download/5/0/5/505FFC2C-8E37-41A0-8746-F9F3CF9FD8F9/BingDesktopSetup.exe"

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
