$packageName = "mydev-database"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    sc.exe config "RavenDb" start= demand
    sc.exe config "MongoDb" start= demand
    sc.exe config "MSSQLSERVER" start= demand
    sc.exe config "MySql" start= demand

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
