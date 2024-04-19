### Power Settings

Write-Output "On AC - monitor off at 30 minutes, standby never, hibernate never..."

powercfg.exe /change monitor-timeout-ac 30
powercfg.exe /change standby-timeout-ac 0
powercfg.exe /change hibernate-timeout-ac 0
