$packageName = "tightvnc"
$installerType = "MSI"
$installerArgs = "/quiet /norestart"
$url = "http://www.tightvnc.com/download/2.8.5/tightvnc-2.8.5-gpl-setup-32bit.msi"
$url64 = "http://www.tightvnc.com/download/2.8.5/tightvnc-2.8.5-gpl-setup-64bit.msi"
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
