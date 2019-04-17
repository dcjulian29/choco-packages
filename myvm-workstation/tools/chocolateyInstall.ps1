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

# Disable OneDrive inside my VMs
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive"
$Name = "DisableFileSyncNGSC"
$value = "1"

if (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name $name -Value $value `
        -PropertyType DWORD -Force | Out-Null
} else {
    Set-ItemProperty -Path $registryPath -Name $name -Value $value `
        -PropertyType DWORD -Force | Out-Null}

$url = "http://www.nirsoft.net/utils/searchmyfiles.zip"
$url64 = "http://www.nirsoft.net/utils/searchmyfiles-x64.zip"
$installFile = Join-Path $PSScriptRoot "searchmyfiles.exe"

Install-ChocolateyZipPackage -PackageName "searchmyfiles" -Url $url -url64 $url64 -UnzipLocation $PSScriptRoot

Set-Content -Path "$installFile.gui" -Value $null
