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

gd -Key "code" -delete
gd -Key "code" -SelectedPath "${env:SYSTEMDRIVE}\code" -add
gd -Key "projects" -delete
gd -Key "projects" -SelectedPath "${env:SYSTEMDRIVE}\code" -add

[System.Environment]::SetEnvironmentVariable('CAKE_SETTINGS_SKIPPACKAGEVERSIONCHECK', 'true',[System.EnvironmentVariableTarget]::User)

Write-Output "Checking to see if code folder needs to be restored..."
if (-not (Test-Path "$(Get-DefaultCodeFolder)\BACKUP-CodeDirectory.bat")) {
    if (Test-Path $env:SYSTEMDRIVE\etc\Restore-CodeDirectory.cmd) {
        Write-Output "  - Restoring code folder..."
        & $env:SYSTEMDRIVE\etc\Restore-CodeDirectory.cmd
    }
}
