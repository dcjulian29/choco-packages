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

# Disable OneDrive inside my VMs
$registryPath = "SOFTWARE\Policies\Microsoft\Windows\OneDrive"
$Name = "DisableFileSyncNGSC"
$value = "1"

if (!(Test-Path "HKLM:\$registryPath")) {
    New-Item -Path "HKLM:\$registryPath" -Force | Out-Null
    New-ItemProperty -Path "HKLM:\$registryPath" -Name $name -Value $value `
        -PropertyType DWORD -Force | Out-Null
} else {
    [Microsoft.Win32.Registry]::SetValue( `
        "HKEY_LOCAL_MACHINE\$RegistryPath", $name, $value, `
        [Microsoft.Win32.RegistryValueKind]::DWord)
}
