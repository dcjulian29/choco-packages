### Power Settings

Write-Output "On AC - hibernate never..."

powercfg.exe /change hibernate-timeout-ac 0
