$packageName = "myvm-development"

$ErrorActionPreference = "Stop"

Write-Output "Installing .Net 3.x Framework..."

Enable-WindowsOptionalFeature -All -FeatureName NetFx3 -Online

Write-Output "Installing Windows Container Support..."

Enable-WindowsOptionalFeature -All -FeatureName Containers -Online -NoRestart

Write-Output "Installing Windows Hyper-V Support..."

Enable-WindowsOptionalFeature -All -FeatureName Microsoft-Hyper-V-All -Online -NoRestart

Write-Output "Initial Setup of Development Workstation Finished. Rebooting in 30 seconds..."

Start-Sleep -Seconds 30

Restart-Computer -Force
