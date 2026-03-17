# ~~~ Prevent Windows from taking known ports

# Generic web sites (3000,8000-8099,9000)
netsh int ipv4 add excludedportrange protocol=tcp startport=3000 numberofports=1
netsh int ipv4 add excludedportrange protocol=tcp startport=8000 numberofports=100
netsh int ipv4 add excludedportrange protocol=tcp startport=9000 numberofports=1

# ~~~ Go language development stuff

go install github.com/spf13/cobra-cli@latest
go install golang.org/x/lint/golint@latest
go install github.com/securego/gosec/v2/cmd/gosec@latest

# ~~~ Disable OneDrive

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

# ~~~ Folders, Icons, and Links

$files = @{
  bin  = "C:\WINDOWS\System32\SHELL32.dll,212"
  code   = "$env:USERPROFILE\executor\folder-development.ico,0"
  etc  = "C:\WINDOWS\System32\SHELL32.dll,314"
}

$files.Keys | ForEach-Object {
  if (-not (Test-Path $env:USERPROFILE\$_)) {
    New-Item -Type Directory -Path $env:USERPROFILE\$_ | Out-Null
  }

  Set-Content $env:USERPROFILE\$_\desktop.ini @"
[.ShellClassInfo]
IconResource=$files[$_]
[ViewState]
Mode=
Vid=
FolderType=Generic
"@

  attrib.exe +S +H $env:USERPROFILE\$_\desktop.ini
  attrib.exe +R $env:USERPROFILE\$_
}

if (-not (Test-Path $env:SystemDrive\bin)) {
  New-Item -ItemType SymbolicLink -Path $env:SystemDrive\bin `
    -Target $env:USERPROFILE\bin
}

if (-not (Test-Path $env:SystemDrive\etc)) {
  New-Item -ItemType SymbolicLink -Path $env:SystemDrive\etc `
    -Target $env:USERPROFILE\etc
}

# ~~~ Directories for document and picture syncing

if (-not (Test-Path $env:USERPROFILE\Documents\devvm)) {
  New-Item -Type Directory -Path $env:USERPROFILE\Documents\devvm | Out-Null
}

if (-not (Test-Path $env:USERPROFILE\Pictures\devvm)) {
  New-Item -Type Directory -Path $env:USERPROFILE\Pictures\devvm | Out-Null
}

# ~~~ Syncthing configuration install if present

if (Get-Process -Name "syncthing" -ea 0) {
  Get-Process -Name "syncthing" | Stop-Process -Force
}

$src = "${env:SystemRoot}\Setup\Scripts"
$dst = "$env:LOCALAPPDATA\Syncthing"

if (-not (Test-Path $dst)) {
    New-Item -Path $dst -ItemType Directory | Out-Null
}

if (Test-Path "$src\config.xml") {
    Move-Item -Path "$src\key.pem" -Destination "$dst\key.pem"
    Move-Item -Path "$src\cert.pem" -Destination "$dst\cert.pem"
    Move-Item -Path "$src\config.xml" -Destination "$dst\config.xml"
}

# ~~~ Development Wallpaper

$file = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) "codebackground.jpg"
$wallpaper = "$($env:PUBLIC)\Pictures\wallpaper.png"

Add-Type @"
using System;
using System.Runtime.InteropServices;
using Microsoft.Win32;
public class Win32Api {
    [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

if (Test-Path $wallpaper) {
  Remove-Item -Path $wallpaper -Force
}

Copy-Item -Path $file -Destination $wallpaper -Force

Set-ItemProperty -Path "HKCU:Control Panel\Desktop" -Name "WallPaperStyle" -Value "2"
Set-ItemProperty -Path "HKCU:Control Panel\Desktop" -Name "TileWallPaper" -Value "0"

[Win32Api]::SystemParametersInfo(20, 0, $wallpaper, 3);

# ~~~ Finished Setup of Development VM

Write-Output "Finished Setup of Development VM Finished. Rebooting in 30 seconds..."

Start-Sleep -Seconds 30

Restart-Computer -Force
