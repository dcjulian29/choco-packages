$packageName = "nuget"
$appDir = "$($env:ChocolateyInstall)\apps\$($packageName)"
$link = "$($env:ChocolateyInstall)\bin\nuget.exe"

try
{
    if (Test-Path $appDir)
    {
      Remove-Item "$($appDir)" -Recurse -Force
    }

    if (Test-Path $link) {
        Remove-Item $link -Force
    }
    
    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
