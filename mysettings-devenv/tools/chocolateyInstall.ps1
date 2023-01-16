$icon = "https://www.iconfinder.com/icons/37070/download/ico"

if (-not (Test-Path $env:SYSTEMDRIVE\code))
{
    New-Item -Type Directory -Path $env:SYSTEMDRIVE\code | Out-Null
}

Set-Content $env:SYSTEMDRIVE\code\desktop.ini @"
[.ShellClassInfo]
IconResource=$env:SYSTEMDRIVE\etc\executor\folder-development.ico,0
[ViewState]
Mode=
Vid=
FolderType=Generic
"@

attrib.exe +S +H $env:SYSTEMDRIVE\code\desktop.ini
attrib.exe +R $env:SYSTEMDRIVE\code

Add-FavoriteFolder -Key "code" -Path "${env:SYSTEMDRIVE}\code" -Force
Add-FavoriteFolder -Key "projects" -Path "${env:SYSTEMDRIVE}\code" -Force

[System.Environment]::SetEnvironmentVariable('CAKE_SETTINGS_SKIPPACKAGEVERSIONCHECK', 'true',[System.EnvironmentVariableTarget]::User)
