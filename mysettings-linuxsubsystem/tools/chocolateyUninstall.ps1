if (Test-Path $env:SYSTEMDRIVE\Ubuntu) {
    Remove-Item -Path $env:SYSTEMDRIVE\Ubuntu -Recurse -Force | Out-Null
}
