$packageName = "posh-mymodules"
$appDir = "$($env:UserProfile)\Documents\WindowsPowerShell\MyModules"

if (Test-Path $appDir) {
    Remove-Item -Path $appDir -Recurse -Force
}
