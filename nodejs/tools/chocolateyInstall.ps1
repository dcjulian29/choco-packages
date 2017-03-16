$packageName = "nodejs"
$installerType = "MSI"
$installerArgs = "/qb"

$version = "7.6.0"
$rootUrl = "https://nodejs.org/dist/v$version"

$url = "$rootUrl/node-v$version-x86.msi"
$url64 = "$rootUrl/node-v$version-x64.msi"

$downloadPath = "$env:TEMP\$packageName\"

if ([System.IntPtr]::Size -ne 4) {
    $url = $url64
}

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.$installerType"

Invoke-ElevatedCommand "$downloadPath\$packageName.$installerType" -ArgumentList $installerArgs -Wait
