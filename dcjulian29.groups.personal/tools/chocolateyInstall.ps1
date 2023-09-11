if (-not ([bool](Invoke-Command -ComputerName $env:COMPUTERNAME `
    -ScriptBlock {IPConfig} -ErrorAction SilentlyContinue))) {
  Write-Output "Enabling Remote Management..."

  Enable-PSRemoting -Force -SkipNetworkProfileCheck

  Set-NetFirewallRule -Name 'WINRM-HTTP-In-TCP'  -Enabled True -Profile Domain
  Set-NetFirewallRule -Name 'WINRM-HTTP-In-TCP'  -Enabled True -Profile Private
}

if (-not (Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V).State -eq "Enabled") {
  Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -NoRestart
}

if (-not (Get-WindowsOptionalFeature -Online -FeatureName Containers).State -eq "Enabled") {
  Enable-WindowsOptionalFeature -Online -FeatureName Containers -All -NoRestart
}

if (-not (Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux).State `
    -eq "Enabled") {
  Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart

  Write-Warning "You must reboot before using the Linux Subsystem..."
}

if ([System.Environment]::OSVersion.Version.Build -ge 19041) {
  if (-not (Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform).State `
      -eq "Enabled") {
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart

    Write-Warning "You may need to reboot before using the Virtual Machine Platform..."
  }
} else {
  Write-Output "WSL 2 is not available on this build of Windows: " `
    + "$([System.Environment]::OSVersion.Version.Build)"
}

#-------------------------------------------------------------------------------

if (-not (Test-Path "${env:SystemDrive}\Virtual Machines")) {
  New-Item -Path "${env:SystemDrive}\Virtual Machines" -ItemType Directory | Out-Null
}

if (-not (Test-Path "${env:SystemDrive}\Virtual Machines\ISO")) {
  New-Item -Path "${env:SystemDrive}\Virtual Machines\Hyper-V" -ItemType Directory | Out-Null
}

if (-not (Get-VMSwitch -Name LAB -ErrorAction SilentlyContinue)) {
  New-VMSwitch -Name LAB -SwitchType Internal
  New-NetIPAddress -IPAddress 10.10.10.11 -PrefixLength 24 -InterfaceAlias "vEthernet (LAB)"
  Set-NetConnectionProfile `
    -InterfaceIndex $((Get-NetConnectionProfile -InterfaceAlias "vEthernet (LAB)").InterfaceIndex) `
    -NetworkCategory Private
}

if (-not (Test-Path "${env:SystemDrive}\Virtual Machines\Hyper-V")) {
  New-Item -Path "${env:SystemDrive}\Virtual Machines\Hyper-V" -ItemType Directory | Out-Null
}

Set-VMHost -VirtualMachinePath "${env:SystemDrive}\Virtual Machines\Hyper-V"
Set-VMHost -VirtualHardDiskPath "${env:SystemDrive}\Virtual Machines\Hyper-V\Discs"

if (-not (Test-Path "${env:USERPROFILE}\code")) {
  New-Item -Type Directory -Path "${env:USERPROFILE}\code" | Out-Null
}

Set-Content -Path "${env:USERPROFILE}\code\desktop.ini" -Value @"
[.ShellClassInfo]
IconResource=${env:SYSTEMDRIVE}\etc\executor\folder-development.ico,0
[ViewState]
Mode=
Vid=
FolderType=Generic
"@

attrib.exe +S +H $env:USERPROFILE\code\desktop.ini
attrib.exe +R $env:USERPROFILE\code

# ~~~ Prevent Windows from taking known ports

if (-not (Test-Path -Path "${env:TEMP}\dcjulian29.groups.personal.update.txt")) {
  if (Get-Process -Name "syncthing" -ea 0) {
    Get-Process -Name "syncthing" | Stop-Process -Force
  }

  # Generic web sites (3000,8000-8099,9000)
  netsh int ipv4 add excludedportrange protocol=tcp startport=3000 numberofports=1
  netsh int ipv4 add excludedportrange protocol=tcp startport=8000 numberofports=100
  netsh int ipv4 add excludedportrange protocol=tcp startport=9000 numberofports=1

  # SyncThing
  netsh int ipv4 add excludedportrange protocol=tcp startport=8384 numberofports=1
  netsh int ipv4 add excludedportrange protocol=tcp startport=22000 numberofports=1
  netsh int ipv4 add excludedportrange protocol=udp startport=22000 numberofports=1
}

# ~~~ Go language development stuff...

if (-not (Test-Path -Path "${env:TEMP}\dcjulian29.groups.personal.update.txt")) {
  go install github.com/goreleaser/goreleaser@latest
  go install github.com/spf13/cobra-cli@latest
  go install golang.org/x/lint/golint@latest
}

# ~~~ EOF

if (Test-Path -Path "${env:TEMP}\dcjulian29.groups.personal.update.txt") {
  Remove-Item -Path "${env:TEMP}\dcjulian29.groups.personal.update.txt" -Force
}
