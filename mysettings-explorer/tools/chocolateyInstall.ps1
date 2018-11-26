$packageName = "mysettings-explorer"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

$cmd = "$env:WINDIR\system32\reg.exe import $toolDir\registry.reg"

if (Get-ProcessorBits -eq 64) {
    $cmd = "$cmd /reg:64"
}

cmd /c "$cmd"

powercfg.exe /change monitor-timeout-ac 10
powercfg.exe /change standby-timeout-ac 0
powercfg.exe /change hibernate-timeout-ac 0

powercfg.exe /change monitor-timeout-dc 5
powercfg.exe /change standby-timeout-dc 10
powercfg.exe /change hibernate-timeout-dc 30

Write-Output "You need to reboot to complete the action..."
