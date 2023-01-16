$psremote = ([bool](Invoke-Command -ComputerName $env:COMPUTERNAME `
    -ScriptBlock {IPConfig} -ErrorAction SilentlyContinue))

$hyperv = (Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V).State -eq "Enabled"

$containers = (Get-WindowsOptionalFeature -Online -FeatureName Containers).State -eq "Enabled"

$wsl = (Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux).State -eq "Enabled"

if (-not $psremote) {
    Write-Output "Enabling Remote Management..."

    Enable-PSRemoting -Force -SkipNetworkProfileCheck

    Set-NetFirewallRule -Name 'WINRM-HTTP-In-TCP'  -Enabled True -Profile Domain
    Set-NetFirewallRule -Name 'WINRM-HTTP-In-TCP'  -Enabled True -Profile Private
}

if (-not $hyperv) {
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
}

if (-not (Test-Path "$env:SystemDrive\Virtual Machines")) {
  New-Item -Path "$env:SystemDrive\Virtual Machines" -ItemType Directory | Out-Null
}

if (-not (Test-Path "$env:SystemDrive\Virtual Machines\ISO")) {
  New-Item -Path "$env:SystemDrive\Virtual Machines\Hyper-V" -ItemType Directory | Out-Null
}

Add-FavoriteFolder -Key "iso" -Path "$env:SystemDrive\Virtual Machines\ISO" -Force

if (-not $containers) {
    Enable-WindowsOptionalFeature -Online -FeatureName Containers -All -NoRestart
}

if (-not $wsl) {
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart

    Write-Warning "You must reboot before using the Linux Subsystem..."
}

if ([System.Environment]::OSVersion.Version.Build -ge 19041) {
    $vmp = (Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform).State -eq "Enabled"

    if (-not $vmp) {
        Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart

        Write-Warning "You may need to reboot before using the Virtual Machine Platform..."
    }
} else {
    Write-Output "WSL 2 is not available on this build of Windows: $([System.Environment]::OSVersion.Version.Build) "
}

Write-Output "`n`nExcluding Ports for Common Servers so the OS doesn't reserve them..."

if (Get-Process -Name "syncthing" -ea 0) {
    Get-Process -Name "syncthing" | Stop-Process -Force
}

Write-Output "# Web sites (8000-8099)"
netsh int ipv4 add excludedportrange protocol=tcp startport=8000 numberofports=100

Write-Output "# SyncThing"
netsh int ipv4 add excludedportrange protocol=tcp startport=8343 numberofports=1
netsh int ipv4 add excludedportrange protocol=tcp startport=22000 numberofports=1
netsh int ipv4 add excludedportrange protocol=udp startport=22000 numberofports=1

Write-Output "# ELK"
netsh int ipv4 add excludedportrange protocol=tcp startport=5000 numberofports=1
netsh int ipv4 add excludedportrange protocol=udp startport=5000 numberofports=1
netsh int ipv4 add excludedportrange protocol=tcp startport=5044 numberofports=1
netsh int ipv4 add excludedportrange protocol=tcp startport=5601 numberofports=1
netsh int ipv4 add excludedportrange protocol=tcp startport=8514 numberofports=1
netsh int ipv4 add excludedportrange protocol=udp startport=8514 numberofports=1
netsh int ipv4 add excludedportrange protocol=tcp startport=9200 numberofports=1
netsh int ipv4 add excludedportrange protocol=tcp startport=9300 numberofports=1

Write-Output "# mailhog"
netsh int ipv4 add excludedportrange protocol=tcp startport=1025 numberofports=1

Write-Output "# mssql"
netsh int ipv4 add excludedportrange protocol=tcp startport=1433 numberofports=1

Write-Output "# mongo"
netsh int ipv4 add excludedportrange protocol=tcp startport=27017 numberofports=1

Write-Output "# postgresql"
netsh int ipv4 add excludedportrange protocol=tcp startport=5432 numberofports=1

Write-Output "# mysql"
netsh int ipv4 add excludedportrange protocol=tcp startport=3306 numberofports=1

Write-Output "# redis"
netsh int ipv4 add excludedportrange protocol=tcp startport=6379 numberofports=1

netsh int ipv4 show excludedportrange tcp
netsh int ipv4 show excludedportrange udp
