$packageName = "nwagstudio"
$installerType = "MSI"
$installerArgs = "/quiet"
$url = "https://github.com/NSwag/NSwag/releases/download/NSwag-Build-703/NSwagStudio.msi"
$downloadPath = "$env:TEMP\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.$installerType"

Invoke-ElevatedCommand "$downloadPath\$packageName.$installerType" -ArgumentList $installerArgs -Wait
