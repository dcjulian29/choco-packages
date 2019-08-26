if (Get-Process -Name Rainmeter) {
    Stop-Process -Name Rainmeter -Force
}

if (-not (Test-Path $env:APPDATA\Rainmeter)) {
    New-Item -Path $env:APPDATA\Rainmeter -ItemType Directory | Out-Null
}

if (Test-Path $env:APPDATA\Rainmeter\Rainmeter.ini) {
    Remove-Item -Path $env:APPDATA\Rainmeter\Rainmeter.ini -Force
}

if (Test-Path $env:SystemDrive\etc\rainmeter\Rainmeter_$($env:COMPUTERNAME).ini) {
    Copy-Item "${env:SystemDrive}\etc\rainmeter\Rainmeter_$($env:COMPUTERNAME).ini" `
        "${env:APPDATA}\Rainmeter\Rainmeter.ini"
}

if (Test-Path $env:SystemDrive\etc\rainmeter\Layouts_$($env:COMPUTERNAME)) {
    Copy-Item "${env:SystemDrive}\etc\rainmeter\Layouts_$($env:COMPUTERNAME)/" `
        "${env:APPDATA}\Rainmeter\Layouts" -Recurse
}

if (Test-Path $env:USERPROFILE\Documents\Rainmeter) {
    Remove-Item -Path $env:USERPROFILE\Documents\Rainmeter -Recurse -Force
}

Start-Process -FilePath "${env:ProgramFiles}\Rainmeter\Rainmeter.exe"
