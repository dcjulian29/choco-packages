$packageName = "nosqlmanager"
$installerType = "EXE"
$installerArgs = "/SILENT /NORESTART"
$url = "http://www.mongodbmanager.com/files/mongodbmanagerpro_inst.exe"
$downloadPath = "$env:LOCALAPPDATA\Temp\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.$installerType"

Invoke-ElevatedCommand "$downloadPath\$packageName.$installerType" -ArgumentList $installerArgs -Wait

