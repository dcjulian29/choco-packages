$packageName = "sqlmanagementstudio"
$installerType = "EXE"
$installerArgs = "/install /passive /norestart"
$url = "http://download.microsoft.com/download/6/F/C/6FCFDC7F-772F-4FEF-BD48-D75C9A3CFB54/SSMS-Setup-ENU.exe"
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
