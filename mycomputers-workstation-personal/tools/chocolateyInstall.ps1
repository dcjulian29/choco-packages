$packageName = "mycomputers-workstation-personal"

Enable-PSRemoting -Force

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart

Enable-WindowsOptionalFeature -Online -FeatureName containers -All
