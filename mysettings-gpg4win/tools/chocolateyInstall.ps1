$packageName = "mysettings-gpg4win"

$etc = "$($env:SYSTEMDRIVE)\etc"
$up = "$($env:USERPROFILE)"

if (-not $(Test-Path $etc)) {
    New-Item -Type Directory -Path $etc | Out-Null
}

if (-not $(Test-Path "$etc\gnupg")) {
    New-Item -Type Directory -Path "$etc\gnupg" | Out-Null
}

if (Test-Path "$($up)\.gnupg") {
    (Get-Item "$($up)\.gnupg").Delete()
}

cmd /c "mklink /J $($up)\.gnupg $etc\gnupg"

if (Test-Path "$($up)\AppData\Roaming\gnupg") {
    (Get-Item "$($up)\AppData\Roaming\gnupg").Delete()
}

cmd /c "mklink /J $($up)\AppData\Roaming\gnupg $etc\gnupg"
