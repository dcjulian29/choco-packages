$packageName = "mysql-odbc"
$installerType = 'msi'
$silentArgs = '/quiet'

$packageVersion = '5.3.6'

$url = "https://cdn.mysql.com//Downloads/Connector-ODBC/5.3/mysql-connector-odbc-$packageVersion-win32.msi"
$url64 = "https://cdn.mysql.com//Downloads/Connector-ODBC/3.51/mysql-connector-odbc-$packageVersion-winx64.msi"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $silentArgs $url $url64
