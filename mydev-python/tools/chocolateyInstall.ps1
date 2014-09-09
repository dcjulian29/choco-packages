$packageName = "mydev-python"
$shimgen = "$env:ChocolateyInstall\chocolateyinstall\tools\shimgen.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    & C:\python\scripts\pip.exe install pylint
    & $shimgen -o "$env:ChocolateyInstall\bin\pylint.exe" -p "$env:SYSTEMDRIVE\python\scripts\pylint.exe"

    & C:\python\scripts\pip.exe install pep8
    & $shimgen -o "$env:ChocolateyInstall\bin\pep8.exe" -p "$env:SYSTEMDRIVE\python\scripts\pep8.exe"

    & C:\python\scripts\easy_install.exe -U sqlalchemy
    & C:\python\scripts\easy_install.exe -U pymongo
    & C:\python\scripts\easy_install.exe -U winpdb

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
