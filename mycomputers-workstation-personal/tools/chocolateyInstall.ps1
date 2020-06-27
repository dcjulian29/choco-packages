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

        Write-Output "Downloading WSL 2 Kernel Update..."
        Invoke-WebRequest -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" `
            -OutFile "$env:TEMP\wsl_update_x64.msi"

        Start-Process "$env:TEMP\wsl_update_x64.msi" "/passive" -Wait

        Write-Warning "You may need to reboot before using the Virtual Machine Platform..."
    }
} else {
    Write-Output "WSL 2 is not available on this build of Windows: $([System.Environment]::OSVersion.Version.Build) "
}
