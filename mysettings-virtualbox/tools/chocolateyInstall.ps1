$vbox = (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' `
    -Name "VBOX_MSI_INSTALL_PATH").VBOX_MSI_INSTALL_PATH + "VBoxManage.exe"

if (-not (Test-Path $vbox)) {
    throw "VBoxManage.exe not found!"
}

$version = (& "$vbox" --version).Split('r')[0]

$url = "https://download.virtualbox.org/virtualbox/$version/" `
    + "Oracle_VM_VirtualBox_Extension_Pack-$version.vbox-extpack"
$file = "$env:TEMP\Oracle_VM_VirtualBox_Extension_Pack-$version.vbox-extpack"

(New-Object System.Net.WebClient).DownloadFile("$url", $file)

switch ($version) {
    '6.1.30' { $sha = "33d7284dc4a0ece381196fda3cfe2ed0e1e8e7ed7f27b9a9ebc4ee22e24bd23c" }
    '6.1.32' { $sha = "33d7284dc4a0ece381196fda3cfe2ed0e1e8e7ed7f27b9a9ebc4ee22e24bd23c" }
    Default { $sha = "33d7284dc4a0ece381196fda3cfe2ed0e1e8e7ed7f27b9a9ebc4ee22e24bd23c" }
}

& "$vbox" extpack install --accept-license=$sha --replace $file

if ($LastExitCode -ne 0) {
    throw "Extension pack installation failed with exit code '$LastExitCode'"
}

& "$vbox" extpack cleanup

Write-Output "Changing default VM location..."

if (-not (Test-Path "$env:SystemDrive\Virtual Machines\VirtualBox")) {
    New-Item -Path "$env:SystemDrive\Virtual Machines\VirtualBox" -ItemType Directory | Out-Null
}

& "$vbox" setproperty machinefolder "$env:SystemDrive\Virtual Machines\VirtualBox"

vagrant plugin install vagrant-reload winrm winrm-elevated
