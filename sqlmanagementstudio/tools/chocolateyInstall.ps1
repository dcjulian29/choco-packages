$packageName = "sqlmanagementstudio"
$installerType = "EXE"
$installerArgs = "/install /passive /norestart"
$url = "http://download.microsoft.com/download/E/D/3/ED3B06EC-E4B5-40B3-B861-996B710A540C/SSMS-Setup-ENU.exe"
$downloadPath = "$($env:TEMP)\chocolatey\$packageName"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Test-Path $downloadPath)
{
    Remove-Item -Path $downloadPath -Force -Recurse
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url
