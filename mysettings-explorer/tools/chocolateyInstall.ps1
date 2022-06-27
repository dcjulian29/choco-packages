$cmd = "$env:WINDIR\system32\reg.exe import $PSScriptRoot\registry.reg"

if ([System.IntPtr]::Size -ne 4) {
    $cmd = "$cmd /reg:64"
}

Write-Output "Adding explorer settings to registry..."
cmd /c "$cmd"

Write-Output "You need to reboot to complete the action..."
