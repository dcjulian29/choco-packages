$packageName = "git"
$installerType = "EXE"
$installerArgs = '/SILENT /COMPONENTS="!ext,!ext\cheetah,!assoc,!assoc_sh"'
$url = "https://github.com/msysgit/msysgit/releases/download/Git-1.9.5-preview20141217/Git-1.9.5-preview20141217.exe"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url

    if (Test-ProcessAdminRights) {
        . "$toolDir\postInstall.ps1"
    } else {
        Start-ChocolateyProcessAsAdmin ". $toolDir\postInstall.ps1"
    }

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
