New-LabVMSwitch
Set-VMHost -VirtualMachinePath 'C:\Virtual Machines'
Set-VMHost -VirtualHardDiskPath 'C:\Virtual Machines\Discs'

if (-not (Test-Path $env:SYSTEMDRIVE\Ubuntu\rootfs)) {
    Write-Output "Ubuntu Linux has been installed...  Starting final install."

    Start-Process -FilePath $env:SYSTEMDRIVE\Ubuntu\ubuntu1804.exe `
        -ArgumentList "install --root" -NoNewWindow -Wait

    Start-Process -FilePath $env:SYSTEMDRIVE\Ubuntu\ubuntu1804.exe `
        -ArgumentList "run adduser $($env:USERNAME) --gecos ""First,Last,RoomNumber,WorkPhone,HomePhone"" `
        --disabled-password" -NoNewWindow -Wait

    Start-Process -FilePath $env:SYSTEMDRIVE\Ubuntu\ubuntu1804.exe `
        -ArgumentList "run usermod -aG sudo $($env:USERNAME)" -NoNewWindow -Wait

    Start-Process -FilePath $env:SYSTEMDRIVE\Ubuntu\ubuntu1804.exe `
        -ArgumentList "run echo '$($env:USERNAME) ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo" `
        -NoNewWindow -Wait

    Start-Process -FilePath $env:SYSTEMDRIVE\Ubuntu\ubuntu1804.exe `
        -ArgumentList "config --default-user $($env:USERNAME)" -NoNewWindow -Wait

    Start-Process -FilePath $env:SYSTEMDRIVE\Ubuntu\ubuntu1804.exe `
        -ArgumentList "run curl -sSL http://dl.julianscorner.com/l/init.sh | bash" -NoNewWindow -Wait
}

if (Get-Command "minikube.exe") {
    if (-not ($(Get-VM minikube))) {
        Write-Output "Initialize MiniKube and configure its VM ..."

        & minikube.exe config set vm-driver hyperv
        & minikube.exe config set hyperv-virtual-switch "Default Switch"
        & minikube.exe start
        & minikube.exe ssh 'sudo poweroff'

        Set-VMMemory -VMName "minikube" -DynamicMemoryEnabled $false
    }
}
