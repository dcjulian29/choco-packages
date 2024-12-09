$vbox = (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' `
    -Name "VBOX_MSI_INSTALL_PATH").VBOX_MSI_INSTALL_PATH + "VBoxManage.exe"

if (-not (Test-Path $vbox)) {
  throw "VBoxManage.exe not found!"
}

Write-Output "Changing default VM location..."
$machine_folder = "${env:USERPROFILE}\.virtualbox"

if (-not (Test-Path -Path $machine_folder)) {
  New-Item -Path $machine_folder -ItemType Directory | Out-Null
}

& "$vbox" setproperty machinefolder $machine_folder
