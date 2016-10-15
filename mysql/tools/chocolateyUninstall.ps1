$packageName = "mysql"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if (Get-Service | Where-Object { $_.Name -eq $sn }) {
    $cmd = "Stop-Service -ErrorAction 0 -Name $packageName;sc.exe delete $packageName"
    Write-Output "Shutting down MySQL..."
    Invoke-ElevatedExpression $cmd
}

if (Test-Path $appDir) {
    Remove-Item "$($appDir)" -Recurse -Force
}
