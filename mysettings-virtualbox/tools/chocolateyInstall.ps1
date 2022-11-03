$vbox = (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' `
    -Name "VBOX_MSI_INSTALL_PATH").VBOX_MSI_INSTALL_PATH + "VBoxManage.exe"

if (-not (Test-Path $vbox)) {
    throw "VBoxManage.exe not found!"
}

$version = (& "$vbox" --version).Split('r')[0]
$build = (& "$vbox" --version).Split('r')[1]

Write-Output "Downloading extension pack $version-$build..."
$url = "https://download.virtualbox.org/virtualbox/$version/" `
    + "Oracle_VM_VirtualBox_Extension_Pack-$version-$build.vbox-extpack"
$file = "$env:TEMP\Oracle_VM_VirtualBox_Extension_Pack-$version.vbox-extpack"

Remove-Item -Path $file -Force -ErrorAction SilentlyContinue
Download-File -Url $url -Destination $file

$sha = "33d7284dc4a0ece381196fda3cfe2ed0e1e8e7ed7f27b9a9ebc4ee22e24bd23c"

& "$vbox" extpack install --accept-license=$sha --replace $file

if ($LastExitCode -ne 0) {
    throw "Extension pack installation failed with exit code '$LastExitCode'"
}

& "$vbox" extpack cleanup

Remove-Item -Path $file -Force

Write-Output "Changing default VM location..."

if (-not (Test-Path "$env:SystemDrive\Virtual Machines\VirtualBox")) {
    New-Item -Path "$env:SystemDrive\Virtual Machines\VirtualBox" -ItemType Directory | Out-Null
}

& "$vbox" setproperty machinefolder "$env:SystemDrive\Virtual Machines\VirtualBox"

Import-Module "${env:USERPROFILE}\Documents\WindowsPowerShell\Modules\go\go.psm1"

gd -Key "virtualbox" -delete
gd -Key "virtualbox" -SelectedPath "$env:SystemDrive\Virtual Machines\VirtualBox" -add

vagrant plugin install vagrant-reload winrm winrm-elevated
