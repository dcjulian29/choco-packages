$etc = "$($env:SYSTEMDRIVE)\etc"
$up = "$($env:USERPROFILE)"

if (-not $(Test-Path $etc)) {
    New-Item -Type Directory -Path $etc | Out-Null
}

if (-not $(Test-Path "$etc\git")) {
    New-Item -Type Directory -Path "$etc\git" | Out-Null
}

if (-not $(Test-Path "$etc\git\gitconfig")) {
    New-Item -ItemType File "$etc\git\gitconfig"
}

if (Test-Path "$($up)\.gitconfig") {
    (Get-Item "$($up)\.gitconfig").Delete()
}

cmd /c "mklink $($up)\.gitconfig $etc\git\gitconfig"
