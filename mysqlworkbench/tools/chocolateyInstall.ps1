$packageName = "mysqlworkbench"
$installerType = "MSI"
$installerArgs = "/passive /norestart"
$url = "http://cdn.mysql.com/Downloads/MySQLGUITools/mysql-workbench-community-6.3.6-win32.msi"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
