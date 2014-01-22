$etc = "$($env:SYSTEMDRIVE)\etc"
$up = "$($env:USERPROFILE)"

if (-not $(Test-Path $etc)) {
    mkdir $etc
}

if (-not $(Test-Path "$etc\git")) {
    mkdir "$etc\git"
}

if (-not $(Test-Path "$etc\git\gitconfig")) {
    New-Item -ItemType File "$etc\git\gitconfig"
}

if (-not $(Test-Path "$etc\git\gitignore")) {
    New-Item -ItemType File "$etc\git\gitignore"
}

if (Test-Path "$($up)\.gitconfig") {
    (Get-Item "$($up)\.gitconfig").Delete()
}

cmd /c "mklink $($up)\.gitconfig $etc\git\gitconfig"

if (Test-Path "$($up)\.gitignore") {
    (Get-Item "$($up)\.gitignore").Delete()
}

cmd /c "mklink $($up)\.gitignore $etc\git\gitignore"
