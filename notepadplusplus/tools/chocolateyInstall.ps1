$packageName = "notepadplusplus"
$installerType = "EXE"
$installerArgs = "/S"
$url = 'https://notepad-plus-plus.org/repository/7.x/7.1/npp.7.1.Installer.exe'
$downloadPath = "$env:TEMP\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.$installerType"

Invoke-ElevatedCommand "$downloadPath\$packageName.$installerType" -ArgumentList $installerArgs -Wait
