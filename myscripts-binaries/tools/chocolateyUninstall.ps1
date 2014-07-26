$packageName = "myscripts-binaries"
$appDir = "$($env:SYSTEMDRIVE)\tools\binaries"

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
