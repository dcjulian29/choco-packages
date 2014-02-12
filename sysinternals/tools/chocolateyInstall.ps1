$packageName = 'sysinternals'
$appDir = "$($env:ChocolateyInstall)\apps\$($packageName)"
$url = 'http://download.sysinternals.com/files/SysinternalsSuite.zip'
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

try
{
    if (Test-Path $appDir)
    {
      Write-Output "Removing previous version of package..."
      Remove-Item "$($appDir)\*" -Recurse -Force
    }

    Install-ChocolateyZipPackage $packageName $url $appDir

   $cmd = "reg.exe import $toolDir\accepteula.reg"
    
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
