$packageName = "mongodb"
$url = "https://fastdl.mongodb.org/win32/mongodb-win32-x86_64-2008plus-3.2.0.zip"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$dataDir = "$($env:SYSTEMDRIVE)\data\mongo"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Get-Service | Where-Object { $_.Name -eq "MongoDB" }) {
    $cmd = "net.exe stop MongoDB;sc.exe delete MongoDB"
    if (Test-ProcessAdminRights) {
        Invoke-Expression $cmd
    } else {
        Start-ChocolateyProcessAsAdmin $cmd
    }
}

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

if (-not (Test-Path $downloadPath)) {
    New-Item -Type Directory -Path $downloadPath | Out-Null
}

Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url
Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"

$extractPath = $(Get-ChildItem -Directory -Path $downloadPath | Select-Object -First 1).Name

Copy-Item -Path "$($downloadPath)\$($extractPath)\bin\*" -Destination "$appDir" -Recurse
Copy-Item -Path "$($downloadPath)\$($extractPath)\GNU-AGPL-3.0" -Destination "$appDir"

if (-not (Test-Path $dataDir)) {
    New-Item -Type Directory -Path $dataDir | Out-Null
}

$config = "$($appDir)\mongod.cfg"

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

$cmd = "& $appDir\mongod.exe --config ""$appDir\mongod.cfg"" --install"
if (Test-ProcessAdminRights) {
    Invoke-Expression $cmd
} else {
    Start-ChocolateyProcessAsAdmin $cmd
}
