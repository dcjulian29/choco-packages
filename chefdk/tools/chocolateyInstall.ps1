$packageName = "chefdk"
$installerType = "MSI"
$installerArgs = '/passive'
$url = "https://packages.chef.io/stable/windows/2012r2/chefdk-0.18.26-1-x86.msi"
$downloadPath = "$env:TEMP\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.$installerType"

Invoke-ElevatedCommand "$downloadPath\$packageName.$installerType" -ArgumentList $installerArgs -Wait
