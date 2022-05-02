$cmd = "$env:WINDIR\system32\reg.exe import '$PSScriptRoot\registry.reg'"

if (Get-ProcessorBits -eq 64) {
    $cmd = "$cmd /reg:64"
}

cmd /c "$cmd"

Copy-Item -Path "$PSScriptRoot\mstsc.exe.manifest" `
    -Destination "$env:SystemRoot\System32\mstsc.exe.manifest" `
    -Force

Write-Output "You need to reboot to complete the action..."
