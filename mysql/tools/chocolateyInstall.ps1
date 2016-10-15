$packageName = "mysql"
$url = "http://cdn.mysql.com/Downloads/MySQL-5.7/mysql-5.7.16-win32.zip"
$url64 = "http://cdn.mysql.com/Downloads/MySQL-5.7/mysql-5.7.16-winx64.zip"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$downloadPath = "$env:TEMP\$packageName"
$dataDir = "$($env:SYSTEMDRIVE)\data\mysql"

if (Get-Service | Where-Object { $_.Name -eq $packageName }) {
    $cmd = "Stop-Service -ErrorAction 0 -Name $packageName;sc.exe delete $packageName"
    Invoke-ElevatedExpression $cmd
}

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

if ([System.IntPtr]::Size -ne 4) {
    $url = $url64
}

Download-File $url "$downloadPath\$packageName.zip"

Unzip-File "$downloadPath\$packageName.zip" "$downloadPath\"

$extractPath = $(Get-ChildItem -Directory -Path $downloadPath | Select-Object -First 1).Name

New-Item -Type Directory -Path $appDir\bin | Out-Null
Copy-Item -Path "$($downloadPath)\$($extractPath)\bin\*" -Destination "$appDir\bin" -Recurse

New-Item -Type Directory -Path $appDir\bin\share | Out-Null
Copy-Item -Path "$($downloadPath)\$($extractPath)\share\*" -Destination "$appDir\bin\share" -Recurse

if (-not (Test-Path $dataDir)) {
    New-Item -Type Directory -Path $dataDir | Out-Null
}

$config = "$appDir\my.ini"

Set-Content -Path $config -Encoding Ascii -Value "[mysqld]"
Add-Content -Path $config -Encoding Ascii -Value "basedir=$(""$appDir\bin"" -replace '\\', '\\')"
Add-Content -Path $config -Encoding Ascii -Value "datadir=$($dataDir -replace '\\', '\\')"

Invoke-ElevatedExpression "& $appDir\bin\mysqld.exe --install"
