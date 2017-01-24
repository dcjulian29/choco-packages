$packageName = "git-credential-manager"
$url = "https://github.com/Microsoft/Git-Credential-Manager-for-Windows/releases/download/v1.8.0/GCMW-1.8.0.exe"
$installerType = "exe"
$installerArgs = "/SILENT /NORESTART"
$downloadPath = "$env:TEMP\$packageName"
 
if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.$installerType"

Invoke-ElevatedCommand "$downloadPath\$packageName.$installerType" -ArgumentList $installerArgs -Wait
