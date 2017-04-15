$packageName = "regexbuilder"
$appDir = "$($env:SYSTEMDRIVE)\tools\$($packageName)"

if (Test-Path $appDir) {
    Remove-Item "$($appDir)" -Recurse -Force
}
