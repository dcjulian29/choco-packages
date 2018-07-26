$packageName = "mysettings-rainmeter"

if (Get-Process -Name Rainmeter) {
    Stop-Process -Name Rainmeter -Force
}

$drives = (Get-Disk | Where-Object { $_.BusType -ne "USB" } `
    | ForEach-Object { Get-Partition -DiskNumber $_.Number  `
    | Where-Object { $_.DriveLetter } }).PartitionNumber.Count

if (Test-Path $env:APPDATA\Rainmeter\Rainmeter.ini) {
    Remove-Item -Path $env:APPDATA\Rainmeter\Rainmeter.ini -Force
}

Set-Content -Path $env:APPDATA\Rainmeter\Rainmeter.ini -Value @"
[Rainmeter]
Logging=0
SkinPath=C:\etc\Rainmeter\Skins\

[Julian\Disk]
Active=$drives
WindowX=1710
WindowY=248
ClickThrough=0
Draggable=1
SnapEdges=1
KeepOnScreen=1
AlwaysOnTop=0

[Julian\Network]
Active=1
WindowX=1660
WindowY=100
ClickThrough=0
Draggable=1
SnapEdges=1
KeepOnScreen=1
AlwaysOnTop=0

[Julian\System]
Active=1
WindowX=1323
WindowY=656
ClickThrough=0
Draggable=1
SnapEdges=1
KeepOnScreen=1
AlwaysOnTop=0

[Julian\Weather]
Active=1
WindowX=-1920
WindowY=0
ClickThrough=0
Draggable=1
SnapEdges=1
KeepOnScreen=1
AlwaysOnTop=0
"@

Start-Process -FilePath $env:APPDATA\Rainmeter\Rainmeter.exe
