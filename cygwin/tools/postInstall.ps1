$etc = "$($env:SYSTEMDRIVE)\etc"
$up = "$($env:USERPROFILE)"


if (-not $(Test-Path $etc)) {
    New-Item -Type Directory -Path $etc | Out-Null
}

if (-not $(Test-Path "$etc\ssh")) {
    New-Item -Type Directory -Path "$etc\ssh" | Out-Null
}

if (Test-Path "$($up)\.ssh") {
    (Get-Item "$($up)\.ssh").Delete()
}

cmd /c "mklink /J $($up)\.ssh $etc\ssh"


if (-not $(Test-Path "$etc\cygwin")) {
    New-Item -Type Directory -Path "$etc\cygwin" | Out-Null
}

function make-filelink ($filename) {
    if (-not $(Test-Path "$etc\cygwin\$filename")) {
        New-Item -ItemType File "$etc\cygwin\$filename"
    }

    if (Test-Path "$($up)\.$filename") {
        (Get-Item "$($up)\.$filename").Delete()
    }

    cmd /c "mklink $($up)\.$filename $etc\cygwin\$filename"
}

make-filelink bash_logout
make-filelink bash_profile
make-filelink bashrc
make-filelink inputrc
make-filelink minttyrc
make-filelink profile
make-filelink Xresources
