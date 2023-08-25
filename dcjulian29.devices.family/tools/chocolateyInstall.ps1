if (Test-Path "${env:SYSTEMDRIVE}\home") {
    Remove-Item -Path $env:SYSTEMDRIVE\home -Recurse -Force
}

if (Test-Path "${env:SYSTEMDRIVE}\tools") {
    Remove-Item -Path $env:SYSTEMDRIVE\tools -Recurse -Force
}
