New-LabVMSwitch

if (-not (Test-Path "$env:SystemDrive\Virtual Machines\Hyper-V")) {
  New-Item -Path "$env:SystemDrive\Virtual Machines\Hyper-V" -ItemType Directory | Out-Null
}

Set-VMHost -VirtualMachinePath "$env:SystemDrive\Virtual Machines\Hyper-V"
Set-VMHost -VirtualHardDiskPath "$env:SystemDrive\Virtual Machines\Hyper-V\Discs"

Add-FavoriteFolder -Key "hyperv" -Path "$env:SystemDrive\Virtual Machines\Hyper-V" -Force
