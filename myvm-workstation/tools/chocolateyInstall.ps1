$packageName = "myvm-workstation"

if (-not (Test-Path $env:SYSTEMDRIVE\tools)) {
    New-Item -Type Directory -Path $env:SYSTEMDRIVE\tools | Out-Null
}

Set-Content $env:SYSTEMDRIVE\tools\desktop.ini @"
[.ShellClassInfo]
IconResource=$env:WINDIR\system32\SHELL32.dll,218
[ViewState]
Mode=
Vid=
FolderType=Generic
"@

attrib.exe +S +H $env:SYSTEMDRIVE\tools\desktop.ini
attrib.exe +S $env:SYSTEMDRIVE\tools

if (-not (Test-Path $env:SYSTEMDRIVE\home)) {
    New-Item -Type Directory -Path $env:SYSTEMDRIVE\home | Out-Null
}

Set-Content $env:SYSTEMDRIVE\home\desktop.ini @"
[.ShellClassInfo]
IconResource=$env:WINDIR\system32\SHELL32.dll,150
[ViewState]
Mode=
Vid=
FolderType=Generic
"@
attrib +S +H $env:SYSTEMDRIVE\home\desktop.ini
attrib +S $env:SYSTEMDRIVE\home
