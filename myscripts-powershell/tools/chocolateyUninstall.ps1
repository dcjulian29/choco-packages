$packageName = "myscripts-powershell"
$appDir = "$($env:SYSTEMDRIVE)\tools\powershell"

if (Test-Path $appDir\Modules) {
    Remove-Item "$appdir\Modules" -Force
}

if (Test-Path $appDir)
{
  Remove-Item "$($appDir)/*" -Recurse -Force
}
