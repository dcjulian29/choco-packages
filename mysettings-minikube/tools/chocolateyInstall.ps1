if (Get-Command "minikube.exe") {
    if (-not ($(Get-VM minikube))) {
        Write-Output "Initialize MiniKube and configure its VM ..."

        & minikube.exe config set vm-driver hyperv
        & minikube.exe config set hyperv-virtual-switch "Default Switch"
        & minikube.exe start
        & minikube.exe ssh 'sudo poweroff'

        Set-VMMemory -VMName "minikube" -DynamicMemoryEnabled $false
    } else {
        Write-Output "The 'minikube' VM has already been configured..."
    }
}
