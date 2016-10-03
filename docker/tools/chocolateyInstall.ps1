$packageName = "docker"
$installerType = "MSI"
$installerArgs = '/norestart /passive'
$url = "https://download.docker.com/win/stable/InstallDocker.msi"
$downloadPath = "$env:TEMP\$packageName\"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.$installerType"

Invoke-ElevatedCommand "$downloadPath\$packageName.$installerType" -ArgumentList $installerArgs -Wait
