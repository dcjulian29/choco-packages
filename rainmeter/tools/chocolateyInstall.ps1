$packageName = "rainmeter"
$installerArgs = "/S /STARTUP=1 /ALLUSERS=1"
$url = "https://github.com/rainmeter/rainmeter/releases/download/v3.3.2.2609/Rainmeter-3.3.2.exe"
$downloadPath = "$env:TEMP\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.exe"

Invoke-ElevatedCommand "$downloadPath\$packageName.exe" -ArgumentList $installerArgs -Wait
