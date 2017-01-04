$packageName = "rainmeter"
$installerArgs = "/S /STARTUP=1 /ALLUSERS=1"
$url = "https://github.com/rainmeter/rainmeter/releases/download/v4.0.0.2746/Rainmeter-4.0.exe"
$downloadPath = "$env:TEMP\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.exe"

Invoke-ElevatedCommand "$downloadPath\$packageName.exe" -ArgumentList $installerArgs -Wait
