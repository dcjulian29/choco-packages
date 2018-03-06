$packageName = "mycomputers-workstation-personal"

if (-not ([bool](Invoke-Command -ComputerName $env:COMPUTERNAME `
    -ScriptBlock {"IPConfig"} -ErrorAction SilentlyContinue))) {
    Enable-PSRemoting -Force
}

if (-not ([bool](Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V))) {
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
}

if (-not ([bool](Get-WindowsOptionalFeature -Online -FeatureName Containers))) {
    Enable-WindowsOptionalFeature -Online -FeatureName Containers -All
}
