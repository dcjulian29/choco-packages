$packageName = "winpcap"
$url = "http://www.winpcap.org/install/bin/WinPcap_4_1_3.exe"
$downloadPath = "$env:TEMP\winpcap"

$ahkExe = "$env:ChocolateyInstall\bin\ahk.exe"
$ahkScript = "$PSScriptRoot\install.ahk"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\winpcapInstall.exe"

Invoke-ElevatedCommand -File $ahkExe -ArgumentList $ahkScript -Wait
