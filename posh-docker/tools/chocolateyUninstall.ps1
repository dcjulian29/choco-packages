$packageName = "posh-docker"
$appDir = "$($env:UserProfile)\Documents\WindowsPowerShell\Modules\Docker"

if (Test-Path $appDir)
{
  Remove-Item "$($appDir)" -Recurse -Force
}
