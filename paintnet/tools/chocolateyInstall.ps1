$packageName = "paintnet"
$installerArgs = "/auto DESKTOPSHORTCUT=0"
$version = "4.0.13"
$url = "http://www.dotpdn.com/files/paint.net.$version.install.zip"
$downloadPath = "$env:TEMP\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.zip"

Unzip-File "$downloadPath\$packageName.zip" $downloadPath

Invoke-ElevatedCommand "$downloadPath\paint.net.$version.install.exe" `
    -ArgumentList $installerArgs -Wait
