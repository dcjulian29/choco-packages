$wsl = (Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux).State -eq "Enabled"

if (-not $wsl) {
  throw "WSL feature is not enabled"
}

if ([System.Environment]::OSVersion.Version.Build -ge 19041) {
  $vmp = (Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform).State -eq "Enabled"

  if (-not $vmp) {
    throw "Virtual Machine Platform feature is not enabled"
  }

  if ([System.Environment]::OSVersion.Version.Build -ge 22621) {
    & wsl.exe --update
  } else {
    Write-Output "Downloading WSL 2 Kernel Update..."
    Invoke-WebRequest -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" `
        -OutFile "$env:TEMP\wsl_update_x64.msi"

    $logWslFile = Get-LogFileName -Date $(Get-Date) -Suffix "$env:COMPUTERNAME-wsl2kernel"
    Start-Process "$env:TEMP\wsl_update_x64.msi" "/passive /norestart /log $logWslFile" -Wait
  }

  & wsl.exe --set-default-version 2
}
