$packageName = "wireshark"
$installerType = "EXE"
$installerArgs = "/S /quicklaunchicon=no"
$url = "https://www.wireshark.org/download/win32/all-versions/Wireshark-win32-2.2.0.exe"
$url64 = "https://www.wireshark.org/download/win64/all-versions/Wireshark-win64-2.2.0.exe"
$downloadPath = "$env:TEMP\$packageName\"

if ([System.IntPtr]::Size -ne 4) {
    $url = $url64
}

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

(New-Object System.Net.WebClient).DownloadFile($url, "$downloadPath\$packageName.$installerType")

& "$downloadPath\$packageName.$installerType" $installerArgs
