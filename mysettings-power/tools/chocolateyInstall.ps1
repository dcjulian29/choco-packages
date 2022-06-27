if ($env:COMPUTERNAME -like "*-HPS-*") {
    Write-Output "For Work Computer, turn monitor off after 30 minutes on AC..."
    powercfg.exe /change monitor-timeout-ac 30 # For Work Computer, 30 minutes
} else {
    Write-Output "Prevent monitor from turning off on AC..."
    powercfg.exe /change monitor-timeout-ac 0
}

Write-Output "Prevent auto standby or hibernate on AC..."
powercfg.exe /change standby-timeout-ac 0
powercfg.exe /change hibernate-timeout-ac 0

Write-Output "On battery - monitor off at 5 minutes, standby at 10, hibernate at 30..."
powercfg.exe /change monitor-timeout-dc 5
powercfg.exe /change standby-timeout-dc 10
powercfg.exe /change hibernate-timeout-dc 30

Write-Output "You may need to reboot to complete this change..."
