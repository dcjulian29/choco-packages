$packageName = 'sysinternals'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$appDir = "$(Split-Path -parent $toolsDir)\app"
$url = 'http://download.sysinternals.com/files/SysinternalsSuite.zip'

try
{
    if (Test-Path $appDir)
    {
      Write-Output "Removing previous version of package..."
      Remove-Item "$($appDir)\*" -Recurse -Force
    }

    Install-ChocolateyZipPackage $packageName $url $appDir

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
