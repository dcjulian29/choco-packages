$packageName = "mysettings-explorer"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

$cmd = "$env:WINDIR\system32\reg.exe import $toolDir\registry.reg"

if (Get-ProcessorBits -eq 64) {
    $cmd = "$cmd /reg:64"
}

cmd /c "$cmd"

powercfg.exe /change monitor-timeout-ac 0
powercfg.exe /change standby-timeout-ac 0
powercfg.exe /change hibernate-timeout-ac 0

Write-Output "You need to reboot to complete the action..."
