$packageName = "cs-script"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if (Test-Path $appDir)
{
  Remove-Item "$($appDir)" -Recurse -Force
}

$cmd = "(Get-Item `"`${env:ChocolateyInstall}\bin\cscs.exe`").Delete()"

if (Test-ProcessAdminRights) {
    Invoke-Expression $cmd
} else {
    Start-ChocolateyProcessAsAdmin $cmd
}
