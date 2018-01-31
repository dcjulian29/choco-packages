$packageName = "iperf"
$version = "${env:ChocolateyPackageVersion}"
$url = "https://iperf.fr/download/windows/$($packageName)-$($version)-win64.zip"
$downloadPath = "$env:TEMP\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\$($packageName)"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.zip"

Unzip-File -File "$downloadPath\$packageName.zip" -Destination "$downloadPath\"

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null
    
Copy-Item -Path "$($downloadPath)\$($packageName)-$($version)-win64\*" `
    -Destination "$appDir" -Recurse -Container
