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

"y" | & $vbox extpack install --replace $file

if ($LastExitCode -ne 0) {
    throw "Extension pack installation failed with exit code '$LastExitCode'"
}
