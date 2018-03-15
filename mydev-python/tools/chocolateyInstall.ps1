$packageName = "mydev-python"
$downloadPath = "$env:LOCALAPPDATA\Temp\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Push-Location $downloadPath

& pip.exe install pylint
& pip.exe install pep8
& pip.exe install httpie

& pip.exe install pymongo
& pip.exe install pymysql
& pip.exe install pyodbc
& pip.exe install psycopg2
& pip.exe install tinydb

& pip.exe install redis

& pip.exe install sqlalchemy
& pip.exe install winpdb
