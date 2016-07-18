$packageName = "octopusdeploy"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if (Test-Path $appDir)
{
    Remove-Item "$($appDir)" -Recurse -Force
}
