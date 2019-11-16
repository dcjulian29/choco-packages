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

if (Test-Path $env:SYSTEMDRIVE\etc\SoftwareDevelopment.flt) {
    New-Item $env:USERPROFILE\Documents\WinMerge -ItemType Directory | Out-Null
    New-Item $env:USERPROFILE\Documents\WinMerge\Filters -ItemType Directory | Out-Null
}

Set-Content $env:USERPROFILE\Documents\WinMerge\Filters\SoftwareDevelopment.flt @'
name: Software Development
desc: This filter lets through only files software developers care about
def: include

## Filters for filenames begin with f:
## Filters for directories begin with d:
## (Inline comments begin with " ##" and extend to the end of the line)

f: \.gitignore$
f: \.hgignore$
f: \.svnignore$
f: \.(vs[sp])?scc$
f: \.user$
f: \.bak$
f: StyleCop\.Cache$

d: \\\.vs$
d: \\\.svn$
d: \\_svn$
d: \\\.git$
d: \\\.hg$
d: \\Debug$
d: \\Release$
d: \\bin$
d: \\obj$
d: \\.build$
d: \\build$
d: \\tools$
d: \\packages$
'@

[System.Environment]::SetEnvironmentVariable('CAKE_SETTINGS_SKIPPACKAGEVERSIONCHECK', 'true',[System.EnvironmentVariableTarget]::User)
