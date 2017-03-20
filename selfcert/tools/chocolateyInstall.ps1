$packageName = "selfcert"
$url = "https://s3.amazonaws.com/pluralsight-free/keith-brown/samples/SelfCert.zip"

$downloadPath = "$env:LOCALAPPDATA\Temp\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\$($packageName)"

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.zip"

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Unzip-File "$downloadPath\$packageName.zip" "$downloadPath\"

Copy-Item "$downloadPath\SelfCert\Pluralsight.Crypto.dll" "$appDir"
Copy-Item "$downloadPath\SelfCert\SelfCert.exe" "$appDir"
