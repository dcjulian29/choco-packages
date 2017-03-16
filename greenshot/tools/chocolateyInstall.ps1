$packageName = "greenshot"
$installerArgs = "/SILENT /NORESTART"
$url = "https://github.com/greenshot/greenshot/releases/download/Greenshot-RELEASE-1.2.9.129/Greenshot-INSTALLER-1.2.9.104-RELEASE.exe"
$downloadPath = "$env:TEMP\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.exe"

if (Get-Process $packageName -ErrorAction SilentlyContinue) {
    Stop-Process -ProcessName $packageName -Force -ErrorAction Stop
}

Invoke-ElevatedCommand "$downloadPath\$packageName.exe" -ArgumentList $installerArgs
