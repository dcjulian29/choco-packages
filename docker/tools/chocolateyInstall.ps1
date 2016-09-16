$packageName = "docker"
$installerType = "MSI"
$installerArgs = '/norestart /passive'
$url = "https://download.docker.com/win/stable/InstallDocker.msi"
$downloadPath = "$env:TEMP\$packageName\"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

(New-Object System.Net.WebClient).DownloadFile($url, "$downloadPath\$packageName.$installerType")

& "$downloadPath\$packageName.$installerType" $installerArgs
