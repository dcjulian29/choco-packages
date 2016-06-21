$packageName = "paintnet"
$installerType = "EXE"
$installerArgs = "/auto DESKTOPSHORTCUT=0"
$url = "http://www.dotpdn.com/files/paint.net.4.0.9.install.zip"
$downloadPath = "$env:TEMP\chocolatey\$packageName"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url $url
Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"

Install-ChocolateyPackage $packageName $installerType $installerArgs "$downloadPath\paint.net.4.0.9.install.exe"
