Write-Output "For the laptop when on AC - standby at 60 minutes..."

powercfg.exe /change standby-timeout-ac 60

Write-Output "You may need to reboot to complete this change..."
