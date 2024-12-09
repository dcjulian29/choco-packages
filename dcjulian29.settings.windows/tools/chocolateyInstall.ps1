### Registry Settings

$reg = ""

if ([System.IntPtr]::Size -ne 4) {
    $reg = "/reg:64"
}

Push-Location $PSScriptRoot
(Get-childItem -Path "./"  -Filter "*.reg").Name | ForEach-Object {
  Write-Output "Adding to registry: $($_)"
  cmd /c "$cmd $($_) /f $reg"
}

Pop-Location

### Power Settings

Write-Output "On AC - monitor off at 30 minutes, standby never, hibernate never..."

powercfg.exe /change monitor-timeout-ac 20
powercfg.exe /change standby-timeout-ac 0
powercfg.exe /change hibernate-timeout-ac 60

Write-Output "On battery - monitor off at 5 minutes, standby at 15, hibernate at 30..."

powercfg.exe /change monitor-timeout-dc 15
powercfg.exe /change standby-timeout-dc 20
powercfg.exe /change hibernate-timeout-dc 30

Write-Output "You need to reboot to complete these changes..."
