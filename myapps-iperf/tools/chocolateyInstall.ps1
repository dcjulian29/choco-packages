# One-time package rename
if (Test-Path "../../iperf-julian") {
    Remove-Item -Path "../../iperf-julian" -Recurse -Force
    return
}

$version = "${env:ChocolateyPackageVersion}"
$url = "https://iperf.fr/download/windows/iperf-$($version)-win64.zip"

$downloadPath = "$env:TEMP\$packageName"
$appDir = "$PSScriptRoot\iperf"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Invoke-WebRequest -Uri $url -OutFile "$downloadPath\iperf.zip"
Expand-Archive -Path "$downloadPath\iperf.zip" -Destination "$downloadPath\"

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item $appDir -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Copy-Item -Path "$downloadPath\iperf-$version-win64\*" `
    -Destination "$appDir" -Recurse -Container
