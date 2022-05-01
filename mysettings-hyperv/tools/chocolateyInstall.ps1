New-LabVMSwitch

if (-not (Test-Path "$env:SystemDrive\Virtual Machines\Hyper-V")) {
  New-Item -Path "$env:SystemDrive\Virtual Machines\Hyper-V" -ItemType Directory | Out-Null
}

Set-VMHost -VirtualMachinePath "$env:SystemDrive\Virtual Machines\Hyper-V"
Set-VMHost -VirtualHardDiskPath "$env:SystemDrive\Virtual Machines\Hyper-V\Discs"

Import-Module "${env:USERPROFILE}\Documents\WindowsPowerShell\Modules\go\go.psm1"

gd -Key "hyperv" -delete
gd -Key "hyperv" -SelectedPath "$env:SystemDrive\Virtual Machines\Hyper-V" -add
