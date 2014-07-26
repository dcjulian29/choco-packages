$packageName = "myscripts-development"
$appDir = "$($env:SYSTEMDRIVE)\tools\development"

try
{
    if (Test-Path $appDir)
    {
      Remove-Item "$($appDir)/*" -Recurse -Force
    }

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
