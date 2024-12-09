Write-Output "standby never, hibernate never..."

powercfg.exe /change standby-timeout-ac 0
powercfg.exe /change hibernate-timeout-ac 0
