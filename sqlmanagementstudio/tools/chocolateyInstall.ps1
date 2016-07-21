$packageName = "sqlmanagementstudio"
$installerType = "EXE"
$installerArgs = "/install /passive /norestart"
$url = "http://download.microsoft.com/download/E/4/6/E46671CC-30AA-448F-9A65-0A59A073A3B4/SSMS-Setup-ENU.exe"
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
