$packageName = "xmind"
$installerType = "EXE"
$installerArgs = "/SILENT"
$url = "http://dl3.xmind.net/xmind-7.5-update1-windows.exe"
$downloadPath = "$env:TEMP\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.$installerType"

& "$downloadPath\$packageName.$installerType" $installerArgs

if (Test-Path "$($env:USERPROFILE)\Desktop\XMind 7.lnk") {
    Remove-Item "$($env:USERPROFILE)\Desktop\XMind 7.lnk" -force
}
