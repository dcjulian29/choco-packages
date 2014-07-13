$packageName = "7zip"
$installerType = "MSI"
$installerArgs = "/quiet"
$url = "http://downloads.sourceforge.net/sevenzip/7z922.msi"
$url64 = "http://downloads.sourceforge.net/sevenzip/7z922-x64.msi"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64

    $cmd = "reg.exe import $toolDir\registry.reg"
    
    if (Get-ProcessorBits -eq 64) {
        $cmd = "$cmd /reg:64"
    }

    Start-ChocolateyProcessAsAdmin "$cmd"

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
