$packageName = "posh-nimble"
$appDir = "$($env:UserProfile)\Documents\WindowsPowerShell\Modules\Nimble"

if (Test-Path $appDir)
{
  Remove-Item "$($appDir)" -Recurse -Force
}
