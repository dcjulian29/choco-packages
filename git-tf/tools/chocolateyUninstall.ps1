$packageName = "git-tf"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if (Test-Path $appDir)
{
  Remove-Item "$($appDir)" -Recurse -Force
}

$cmd = "(Get-Item `"`${env:ChocolateyInstall}\bin\gittf.cmd`").Delete()"

if (Test-ProcessAdminRights) {
    Invoke-Expression $cmd
} else {
    Start-ChocolateyProcessAsAdmin $cmd
}
