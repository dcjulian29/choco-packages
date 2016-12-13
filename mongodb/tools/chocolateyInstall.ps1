$packageName = "mongodb"
$installerType = "MSI"
$installerArgs = "/passive /norestart"
$url = "https://fastdl.mongodb.org/win32/mongodb-win32-x86_64-2008plus-ssl-3.4.0-signed.msi"
$downloadPath = "$env:TEMP\$packageName"
$dataDir = "$($env:SYSTEMDRIVE)\data\mongo"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.$installerType"

Invoke-ElevatedCommand "$downloadPath\$packageName.$installerType" -ArgumentList $installerArgs -Wait

if (-not (Test-Path $dataDir)) {
    New-Item -Type Directory -Path $dataDir | Out-Null
}

$config = "$($env:ProgramFiles)\MongoDB\Server\3.4\bin\mongod.cfg"

$dataDir = $dataDir -replace '\\', '/'

Set-Content -Path $config -Encoding Ascii -Value "systemLog:"
Add-Content -Path $config -Encoding Ascii -Value "   destination: file"
Add-Content -Path $config -Encoding Ascii -Value "   path: ""$dataDir/mongodb.log"""
Add-Content -Path $config -Encoding Ascii -Value "   logAppend: true"
Add-Content -Path $config -Encoding Ascii -Value "   verbosity: 1"
Add-Content -Path $config -Encoding Ascii -Value "   traceAllExceptions: true"
Add-Content -Path $config -Encoding Ascii -Value "   logRotate: reopen"
Add-Content -Path $config -Encoding Ascii -Value "net:"
Add-Content -Path $config -Encoding Ascii -Value "   ipv6: true"
Add-Content -Path $config -Encoding Ascii -Value "storage:"
Add-Content -Path $config -Encoding Ascii -Value "   dbPath: ""$dataDir"""
Add-Content -Path $config -Encoding Ascii -Value "   directoryPerDB: true"
Add-Content -Path $config -Encoding Ascii -Value "   engine: wiredTiger"

Invoke-ElevatedCommand "$($env:ProgramFiles)\MongoDB\Server\3.4\bin\mongod.exe" `
    -ArgumentList "--config ""$($env:ProgramFiles)\MongoDB\Server\3.4\bin\mongod.cfg"" --install" `
    -Wait
