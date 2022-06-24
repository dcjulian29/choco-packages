Push-Location $PSScriptRoot

$cmd = "$env:WINDIR\system32\reg.exe import registry.reg"

if ([Environment]::Is64BitOperatingSystem) {
    $cmd = "$cmd /reg:64"
}

cmd /c "$cmd"

Copy-Item -Path "mstsc.exe.manifest" `
    -Destination "$env:SystemRoot\System32\mstsc.exe.manifest" `
    -Force

Write-Output "You need to reboot to complete the action..."

Pop-Location
