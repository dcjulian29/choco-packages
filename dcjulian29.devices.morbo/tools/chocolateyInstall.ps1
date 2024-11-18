# ~~~ Prevent Windows from taking known ports

# SyncThing
netsh int ipv4 add excludedportrange protocol=tcp startport=8384 numberofports=1
netsh int ipv4 add excludedportrange protocol=tcp startport=22000 numberofports=1
netsh int ipv4 add excludedportrange protocol=udp startport=22000 numberofports=1

# ~~~ Go language development stuff...

go install github.com/goreleaser/goreleaser/v2@latest
go install github.com/spf13/cobra-cli@latest
go install golang.org/x/lint/golint@latest

Write-Output "standby never, hibernate never..."

powercfg.exe /change standby-timeout-ac 0
powercfg.exe /change hibernate-timeout-ac 0
