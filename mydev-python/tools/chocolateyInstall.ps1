$packageName = "mydev-python"
$downloadPath = "$env:LOCALAPPDATA\Temp\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Push-Location $downloadPath

& pip.exe install pylint
& pip.exe install pep8

& easy_install.exe -U sqlalchemy
& easy_install.exe -U pymongo
& easy_install.exe -U winpdb
