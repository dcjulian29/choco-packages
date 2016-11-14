$packageName = "sqlitebrowser"
$installerType = "EXE"
$installerArgs = "/S"
$url = "https://github.com/sqlitebrowser/sqlitebrowser/releases/download/v3.9.1/DB.Browser.for.SQLite-3.9.1-win32.exe"
$url64 = "https://github.com/sqlitebrowser/sqlitebrowser/releases/download/v3.9.1/DB.Browser.for.SQLite-3.9.1-win64.exe"
$downloadPath = "$env:TEMP\$packageName"

if ([System.IntPtr]::Size -ne 4) {
    $url = $url64
}

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.$installerType"

Invoke-ElevatedCommand "$downloadPath\$packageName.$installerType" -ArgumentList $installerArgs -Wait
