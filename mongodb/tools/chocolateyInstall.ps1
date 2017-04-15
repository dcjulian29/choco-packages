$packageName = "mongodb"
$installerType = "MSI"
$installerArgs = "/passive /norestart"
$version = "${env:ChocolateyPackageVersion}"
$url = "https://fastdl.mongodb.org/win32/mongodb-win32-x86_64-2008plus-ssl-$version-signed.msi"
$downloadPath = "$env:LOCALAPPDATA\Temp\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.$installerType"

Invoke-ElevatedCommand "$downloadPath\$packageName.$installerType" -ArgumentList $installerArgs -Wait

$root = "$($env:ProgramFiles)\MongoDB\Server\3.4"
$config = "$root\bin\mongod.cfg"
$dataDir = "$root\data"
$dataDir = $($root -replace '\\', '/') + "/data"

if (-not (Test-Path $dataDir)) {
    New-Item -Path $dataDir -Type Directory
}

$logDir= $root -replace '\\', '/'

Set-Content -Path $config -Encoding Ascii -Value "systemLog:"
Add-Content -Path $config -Encoding Ascii -Value "   destination: file"
Add-Content -Path $config -Encoding Ascii -Value "   path: ""$logDir/mongodb.log"""
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

Invoke-ElevatedCommand "$root\bin\mongod.exe" `
    -ArgumentList "--config ""$root\bin\mongod.cfg"" --install" `
    -Wait
