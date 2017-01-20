$packageName = "docker-toolbox"
$installerType = "EXE"
$installerArgs = "/SILENT /COMPONENTS=docker,dockermachine,dockercompose"

$url = "https://github.com/docker/toolbox/releases/download/v1.13.0/DockerToolbox-1.13.0.exe"

$downloadPath = "$env:TEMP\$packageName\"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

(New-Object System.Net.WebClient).DownloadFile($url, "$downloadPath\$packageName.$installerType")

Invoke-Expression "$(Join-Path -Path $downloadPath -ChildPath "$packageName.$installerType") $installerArgs"
