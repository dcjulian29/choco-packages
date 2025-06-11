$wsl = (Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux).State -eq "Enabled"

if (-not $wsl) {
  throw "WSL feature is not enabled"
}

if ([System.Environment]::OSVersion.Version.Build -ge 19041) {
  $vmp = (Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform).State -eq "Enabled"

  if (-not $vmp) {
    throw "Virtual Machine Platform feature is not enabled"
  }

  & wsl.exe --update
  & wsl.exe --set-default-version 2
}
