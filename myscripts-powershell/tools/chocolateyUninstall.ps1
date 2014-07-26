$packageName = "myscripts-powershell"
$appDir = "$($env:SYSTEMDRIVE)\tools\powershell"

try
{
    if (Test-Path $appDir\Modules) {
        Remove-Item "$appdir\Modules" -Force
    }
    
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
