$packageName = "nuget"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$link = "$($env:ChocolateyInstall)\bin\nuget.exe"

if (Test-Path $appDir)
{
  Remove-Item "$($appDir)" -Recurse -Force
}

if (Test-Path $link) {
    Remove-Item $link -Force
}
