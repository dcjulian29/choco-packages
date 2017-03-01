$packageName = "executor"
$packageWildCard = "*$($package)*";
$appDir = "$($env:SYSTEMDRIVE)\tools\$($packageName)"

if (Test-Path $appDir)
{
    Remove-Item "$($appDir)" -Recurse -Force
}

$location = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"

$key = Get-Item $location
if ($key.GetValue("Executor", $null) -ne $null) {
    Remove-ItemProperty -Path $location -Name "Executor"
}
