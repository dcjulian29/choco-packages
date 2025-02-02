# ~~~ Prevent Windows from taking known ports

# SyncThing
netsh int ipv4 add excludedportrange protocol=tcp startport=8384 numberofports=1
netsh int ipv4 add excludedportrange protocol=tcp startport=22000 numberofports=1
netsh int ipv4 add excludedportrange protocol=udp startport=22000 numberofports=1

# ~~~ Prevent Windows from going into standby mode or hibernating

Write-Output "standby never, hibernate never..."

powercfg.exe /change standby-timeout-ac 0
powercfg.exe /change hibernate-timeout-ac 0
