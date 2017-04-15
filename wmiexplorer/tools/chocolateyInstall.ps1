$packageName = "wmiexplorer"
$downloadPath = "$env:LOCALAPPDATA\Temp\$packageName"
$url = "http://www.hostmonitor.biz/download/wmiexplorer.zip"
$appDir = "$($env:SYSTEMDRIVE)\tools\$($packageName)"

if (Test-Path $appDir) {
    Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

if (-not (Test-Path $downloadPath)) {
    New-Item -Type Directory -Path $downloadPath | Out-Null
}

Download-File $url "$downloadPath\$packageName.zip"

Unzip-File "$downloadPath\$packageName.zip" "$appDir\"
