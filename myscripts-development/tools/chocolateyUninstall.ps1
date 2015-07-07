$packageName = "myscripts-development"
$appDir = "$($env:SYSTEMDRIVE)\tools\development"

if (Test-Path $appDir)
{
  Remove-Item "$($appDir)/*" -Recurse -Force
}
