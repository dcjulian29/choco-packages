$packageName = "sqlmanagementstudio"
$installerType = "EXE"
$installerArgs = "/install /passive /norestart"
$url = "http://download.microsoft.com/download/4/7/2/47218E85-5903-4EF4-B54E-3B71DD558017/SSMS-Setup-ENU.exe"
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
