$packageName = "mysettings-xplorer2"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

try
{
    $cmd = "reg.exe import $toolDir\x2settings.reg"
    
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
