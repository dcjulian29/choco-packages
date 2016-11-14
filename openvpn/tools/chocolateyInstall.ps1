$packageName = "openvpn" # arbitrary name for the package, used in messages
$installerType = "exe" #only one of these two: exe or msi
$installerArgs = "/S"
$url = "https://swupdate.openvpn.org/community/releases/openvpn-install-2.3.13-I601-i686.exe"
$url64 = "https://swupdate.openvpn.org/community/releases/openvpn-install-2.3.13-I601-x86_64.exe"
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

Invoke-ElevatedCommand "Remove-Item" -ArgumentList "'$($env:PUBLIC)\Desktop\OpenVPN GUI.lnk' -Force" -Wait

