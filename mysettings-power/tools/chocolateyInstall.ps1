Write-Output "On AC - monitor off at 30 minutes, standby never, hibernate never..."
powercfg.exe /change monitor-timeout-ac 30
powercfg.exe /change standby-timeout-ac 0
powercfg.exe /change hibernate-timeout-ac 0

Write-Output "On battery - monitor off at 5 minutes, standby at 15, hibernate at 30..."
powercfg.exe /change monitor-timeout-dc 5
powercfg.exe /change standby-timeout-dc 15
powercfg.exe /change hibernate-timeout-dc 30

Write-Output "You may need to reboot to complete this change..."
