$packageName = "mysqlworkbench"
$installerType = "MSI"
$installerArgs = "/passive /norestart"
$url = "http://cdn.mysql.com//Downloads/MySQLGUITools/mysql-workbench-community-6.3.8-win32.msi"
$url64 = "http://cdn.mysql.com//Downloads/MySQLGUITools/mysql-workbench-community-6.3.8-winx64.msi"
$vcredist = "https://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x86.exe"
$vcredist64 = "https://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe"

$downloadPath = "$env:TEMP\$packageName"

if ([System.IntPtr]::Size -ne 4) {
    $url = $url64
}

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

if ([System.IntPtr]::Size -ne 4) {
    if (-not (Test-Path "HKLM:SOFTWARE\WOW6432Node\Microsoft\DevDiv\vc\Servicing\12.0")) {
        Download-File $vcredist "$downloadPath\vcredist.exe"

        Invoke-ElevatedCommand "$downloadPath\vcredist.exe" -ArgumentList "/install /passive /norestart" -Wait
    }

    if (-not (Test-Path "HKLM:SOFTWARE\Microsoft\DevDiv\vc\Servicing\12.0")) {
        Download-File $vcredist64 "$downloadPath\vcredist64.exe"

        Invoke-ElevatedCommand "$downloadPath\vcredist64.exe" -ArgumentList "/install /passive /norestart" -Wait
    }
} else {
    if (-not (Test-Path "HKLM:SOFTWARE\Microsoft\DevDiv\vc\Servicing\12.0")) {
        Download-File $vcredist "$downloadPath\vcredist.exe"

        Invoke-ElevatedCommand "$downloadPath\vcredist.exe" -ArgumentList "/install /passive /norestart" -Wait
    }
}

Download-File $url "$downloadPath\$packageName.$installerType"

Invoke-ElevatedCommand "$downloadPath\$packageName.$installerType" -ArgumentList $installerArgs -Wait
