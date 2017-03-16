$packageName = "fiddler"
$installerType = "EXE"
$installerArgs = "/S"
$url = "http://d585tldpucybw.cloudfront.net/docs/default-source/fiddler/fiddler4setup.exe?sfvrsn=46"
$downloadPath = "$env:TEMP\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.$installerType"

Invoke-ElevatedCommand "$downloadPath\$packageName.$installerType" -ArgumentList $installerArgs -Wait
