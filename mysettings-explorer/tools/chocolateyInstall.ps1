$cmd = "$env:WINDIR\system32\reg.exe import '$PSScriptRoot\registry.reg'"

if (Get-ProcessorBits -eq 64) {
    $cmd = "$cmd /reg:64"
}

cmd /c "$cmd"

if ($env:COMPUTERNAME -like "*-HPS-*") {
    powercfg.exe /change monitor-timeout-ac 30 # For Work Computer, 30 minutes
} else {
    powercfg.exe /change monitor-timeout-ac 0
}

powercfg.exe /change standby-timeout-ac 0
powercfg.exe /change hibernate-timeout-ac 0

powercfg.exe /change monitor-timeout-dc 5
powercfg.exe /change standby-timeout-dc 10
powercfg.exe /change hibernate-timeout-dc 30

Write-Output "You need to reboot to complete the action..."
