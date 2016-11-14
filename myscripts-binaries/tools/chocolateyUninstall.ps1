$packageName = "myscripts-binaries"
$appDir = "$($env:SYSTEMDRIVE)\tools\binaries"

if (Test-Path $appDir)
{
  Remove-Item $appDir -Recurse -Force
}
