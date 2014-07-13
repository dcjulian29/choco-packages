$packageName = "octopusdeploy-tool"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\octopus"

try
{
    if (Test-Path $appDir)
    {
      Remove-Item "$($appDir)" -Recurse -Force
    }
    
    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
