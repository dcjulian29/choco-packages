$packageName = "postman"
$installerType = "EXE"
$installerArgs = '-s'
$url = "https://dl.pstmn.io/download/latest/win32"
$url64 = "https://dl.pstmn.io/download/latest/win64"
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
