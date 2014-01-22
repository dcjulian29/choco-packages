$etc = "$($env:SYSTEMDRIVE)\etc"
$up = "$($env:USERPROFILE)"

if (-not $(Test-Path $etc)) {
    mkdir $etc
}

if (-not $(Test-Path "$etc\gnupg")) {
    mkdir "$etc\gnupg"
}

if (Test-Path "$($up)\.gnupg") {
    (Get-Item "$($up)\.gnupg").Delete()
}

cmd /c "mklink /J $($up)\.gnupg $etc\gnupg"

if (Test-Path "$($up)\AppData\Roaming\gnupg") {
    (Get-Item "$($up)\AppData\Roaming\gnupg").Delete()
}

cmd /c "mklink /J $($up)\AppData\Roaming\gnupg $etc\gnupg"
