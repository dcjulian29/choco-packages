$packageName = 'sysinternals'
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if (Test-Path $appDir) {
    Remove-Item "$($appDir)" -Recurse -Force
}

Invoke-ElevatedExpression -Command ". $toolDir\postUninstall.ps1"
