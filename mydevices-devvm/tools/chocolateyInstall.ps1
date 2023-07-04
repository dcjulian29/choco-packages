# .NET 5 and above use the configured TLS version in the operating system
# On the Windows Insiders versions, they changed the default to 1.3
# TLS 1.3 seems to cause issues with NuGet, so disable until they fix it and I validate.
New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Client" -Force | Out-Null

New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Client" `
    -Name "Enabled" -Value "0" -PropertyType DWORD | Out-Null

if (-not (Test-Path $env:SYSTEMDRIVE\code)) {
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

if (-not ([bool](Get-FavoriteFolder -Key "code"))) {
    Add-FavoriteFolder -Key "code" -Path "${env:SYSTEMDRIVE}\code" -Force
}

if (-not ([bool](Get-FavoriteFolder -Key "projects"))) {
    Add-FavoriteFolder -Key "projects" -Path "${env:SYSTEMDRIVE}\code" -Force
}

[System.Environment]::SetEnvironmentVariable('CAKE_SETTINGS_SKIPPACKAGEVERSIONCHECK', 'true',[System.EnvironmentVariableTarget]::User)
