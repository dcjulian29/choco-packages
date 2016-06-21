$packageName = "sqlitebrowser"
$installerType = "EXE"
$installerArgs = "/S"
$url = "https://github.com/sqlitebrowser/sqlitebrowser/releases/download/v3.8.0/sqlitebrowser-3.8.0-win32v3.exe"
$url64 = 'https://github.com/sqlitebrowser/sqlitebrowser/releases/download/v3.8.0/sqlitebrowser-3.8.0-win64v2.exe'

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64
