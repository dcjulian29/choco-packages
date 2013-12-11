$packageName = 'sysinternals'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$appDir = "$(Split-Path -parent $toolsDir)\app"

try
{
    if (Test-Path $appDir)
    {
      Remove-Item "$($appDir)\*" -Recurse -Force
    }

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
