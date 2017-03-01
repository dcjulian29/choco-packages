$packageName = "mysettings-devenv"
$icon = "https://www.iconfinder.com/icons/37070/download/ico"

if (-not (Test-Path $env:SYSTEMDRIVE\code))
{
    New-Item -Type Directory -Path $env:SYSTEMDRIVE\code | Out-Null
}

Download-File $icon $env:SYSTEMDRIVE\code\code.ico

Set-Content $env:SYSTEMDRIVE\code\desktop.ini @"
[.ShellClassInfo]
IconResource=$env:SYSTEMDRIVE\code\code.ico,0
[ViewState]
Mode=
Vid=
FolderType=Generic
"@
 
attrib.exe +S +H $env:SYSTEMDRIVE\code\desktop.ini
attrib.exe +S $env:SYSTEMDRIVE\code

Import-Module "${env:USERPROFILE}\Documents\WindowsPowerShell\Modules\go\go.psm1"
Set-Alias -Name go -Value gd

go -Key "code" -delete
go -Key "code" -SelectedPath "${env:SYSTEMDRIVE}\code" -add
go -Key "projects" -delete
go -Key "projects" -SelectedPath "${env:SYSTEMDRIVE}\code" -add
