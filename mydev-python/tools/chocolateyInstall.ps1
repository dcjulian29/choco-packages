$packageName = "mydev-python"

$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

& C:\python\scripts\pip.exe install pylint
& C:\python\scripts\pip.exe install pep8

& C:\python\scripts\easy_install.exe -U sqlalchemy
& C:\python\scripts\easy_install.exe -U pymongo
& C:\python\scripts\easy_install.exe -U winpdb

if (Test-ProcessAdminRights) {
    . $toolDir\postInstall.ps1
} else {
    Start-ChocolateyProcessAsAdmin ". $toolDir\postInstall.ps1"
}
