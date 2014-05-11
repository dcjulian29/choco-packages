$packageName = "itunes"
$installerType = "EXE"
$installerArgs = "/quiet /norestart"
$url = 'https://secure-appldnld.apple.com/iTunes11/031-3481.20140225.SdYYY/iTunesSetup.exe'
$url64 = 'https://secure-appldnld.apple.com/iTunes11/031-3482.20140225.kdX8s/iTunes64Setup.exe'

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
