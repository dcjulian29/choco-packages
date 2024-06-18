if (-not ([bool](Invoke-Command -ComputerName $env:COMPUTERNAME `
    -ScriptBlock {IPConfig} -ErrorAction SilentlyContinue))) {
  Write-Output "Enabling Remote Management..."

  Enable-PSRemoting -Force -SkipNetworkProfileCheck

  Set-NetFirewallRule -Name 'WINRM-HTTP-In-TCP'  -Enabled True -Profile Domain
  Set-NetFirewallRule -Name 'WINRM-HTTP-In-TCP'  -Enabled True -Profile Private
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

go install github.com/goreleaser/goreleaser/v2@latest
go install github.com/spf13/cobra-cli@latest
go install golang.org/x/lint/golint@latest

# ~~~ EOF

if (Test-Path -Path "${env:TEMP}\dcjulian29.groups.personal.update.txt") {
  Remove-Item -Path "${env:TEMP}\dcjulian29.groups.personal.update.txt" -Force
}
