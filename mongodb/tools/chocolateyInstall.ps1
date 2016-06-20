$packageName = "mongodb"
$installerType = "MSI"
$installerArgs = "/passive /norestart"
$url = "http://downloads.mongodb.org/win32/mongodb-win32-x86_64-2008plus-ssl-3.2.7-signed.msi"
$dataDir = "$($env:SYSTEMDRIVE)\data\mongo"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs "" $url

if (-not (Test-Path $dataDir)) {
    New-Item -Type Directory -Path $dataDir | Out-Null
}

$config = "$($env:ProgramFiles)\MongoDB\Server\3.2\bin\mongod.cfg"

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

$cmd = "& ""$($env:ProgramFiles)\MongoDB\Server\3.2\bin\mongod.exe"" --config ""$($env:ProgramFiles)\MongoDB\Server\3.2\bin\mongod.cfg"" --install"

if (Test-ProcessAdminRights) {
    Invoke-Expression $cmd
} else {
    Start-ChocolateyProcessAsAdmin $cmd
}
