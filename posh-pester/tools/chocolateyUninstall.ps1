$packageName = "posh-pester"
$appDir = "$($env:UserProfile)\Documents\WindowsPowerShell\Modules\pester"

if (Test-Path $appDir)
{
  Remove-Item "$($appDir)" -Recurse -Force
}
