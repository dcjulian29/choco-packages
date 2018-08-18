$packageName = "postgresql"
$url = 'https://get.enterprisedb.com/postgresql/postgresql-10.4-1-windows.exe'
$url64 = 'https://get.enterprisedb.com/postgresql/postgresql-10.4-1-windows-x64.exe'
$installerType = "EXE"
$password = "$env:COMPUTERNAME"
$installerArgs = "--mode unattended --superpassword $password --disable-stackbuilder 1"
$downloadPath = "$env:LOCALAPPDATA\Temp\$packageName"

$service = Get-Service | Where-Object { $_.Name -like "$packageName*" }

if ($service) {
    Invoke-ElevatedExpression "Stop-Service -ErrorAction 0 -Name $($service.Name)"
    Invoke-ElevatedCommand "sc.exe" -ArgumentList "delete $($service.Name)" -Wait
}

if ([System.IntPtr]::Size -ne 4) {
    $url = $url64
}

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.$installerType"

Invoke-ElevatedCommand "$downloadPath\$packageName.$installerType" -ArgumentList $installerArgs -Wait
