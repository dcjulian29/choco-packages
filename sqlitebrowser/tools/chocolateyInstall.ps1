$packageName = "sqlitebrowser"
$installerType = "EXE"
$installerArgs = "/S"
$url = "https://github.com/sqlitebrowser/sqlitebrowser/releases/download/v3.9.0/DB.Browser.for.SQLite-3.9.0-win32.exe"
$url64 = "https://github.com/sqlitebrowser/sqlitebrowser/releases/download/v3.9.0/DB.Browser.for.SQLite-3.9.0-win64.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64
