$packageName = "posh-profile"
$appDir = "$($env:UserProfile)\Documents\WindowsPowerShell"

if (Test-Path $appDir)
{
    Get-ChildItem -Path $appDir -Recurse |
        Select -ExpandProperty FullName |
        Where-Object { $_ -notlike "$appdir\Modules*" } |
        Where-Object { $_ -notlike "$appdir\MyModules*" } |
        Sort-Object Length -Descending |
        Remove-Item -Force
}
