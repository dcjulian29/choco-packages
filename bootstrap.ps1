Set-ExecutionPolicy -Scope LocalMachine RemoteSigned -Force

reg.exe add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartPage /v OpenAtLogon /t REG_DWORD /d 0 /f

if (Test-Path "${env:SYSTEMDRIVE}\Program Files (x86)") {
    $PF32 = "${env:SYSTEMDRIVE}\Program Files (x86)"
} else {
    $PF32 = "${env:SYSTEMDRIVE}\Program Files"
}

setx.exe /m PF32 $PF32

#------------------------------------------------------------------------------

mkdir $env:SYSTEMDRIVE\home

Set-Content $env:SYSTEMDRIVE\home\desktop.ini @"
[.ShellClassInfo]
IconResource=$env:WINDIR\system32\SHELL32.dll,150
[ViewState]
Mode=
Vid=
FolderType=Generic
"@

attrib.exe +S +H $env:SYSTEMDRIVE\home\desktop.ini
attrib.exe +R $env:SYSTEMDRIVE\home

#------------------------------------------------------------------------------

Invoke-WebRequest "https://chocolatey.org/install.ps1" -UseBasicParsing | Invoke-Expression

choco source remove -n"chocolatey"

choco source add --name 'dcjulian29-chocolatey' `
  --source 'https://www.myget.org/F/dcjulian29-chocolatey/api/v2' `
  --priority 2

choco source add --name 'choco' `
  --source 'https://chocolatey.org/api/v2' `
  --priority 3

#------------------------------------------------------------------------------

Write-Output "Restarting Device in 30 seconds..."
Start-Sleep -Seconds 30
Restart-Computer
