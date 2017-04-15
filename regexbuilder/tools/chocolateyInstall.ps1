$packageName = "regexbuilder"
$url = "https://julianscorner.com/downloads/RegexBuilder_1.4.zip"
$downloadPath = "$env:TEMP\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\$($packageName)"

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File -Url $url -Destination "$downloadPath\$packageName.zip"

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item $appDir -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Unzip-File "$downloadPath\$packageName.zip" "$appDir\"
