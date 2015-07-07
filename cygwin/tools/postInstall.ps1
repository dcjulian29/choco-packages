$etc = "$($env:SYSTEMDRIVE)\etc"
$up = "$($env:USERPROFILE)"

if (-not $(Test-Path $etc)) {
    New-Item -Type Directory -Path $etc | Out-Null
}

if (-not $(Test-Path "$etc\ssh")) {
    New-Item -Type Directory -Path "$etc\ssh" | Out-Null
}


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

cmd /c "setx /m TERM msys"
cmd /c "setx /m CYGWIN nodosfilewarning"

$mklink = "cmd.exe /c mklink"

$links = @(
"base64"
"bcrypt"
"bunzip2"
"bzcat"
"bzip2"
"cat"
"cksum"
"curl"
"diff"
"dos2unix"
"gawk"
"grep"
"gzip"
"head"
"hexdump"
"hostid"
"id"
"lynx"
"md5sum"
"nc"
"nc6"
"openssl"
"rsync"
"scp"
"sed"
"setfacl"
"sftp"
"sha1sum"
"sha256sum"
"sha512sum"
"ssh"
"tar"
"tail"
"telnet"
"touch"
"unix2dos"
"unzip"
"uuidgen"
"wget"
"xargs"
"zip"
)

foreach ($link in $links) {
    if (Test-Path "${env:ChocolateyInstall}\bin\$link.bat") {
        (Get-Item "${env:ChocolateyInstall}\bin\$link.bat").Delete()
    }

    Set-Content ${env:ChocolateyInstall}\bin\$link.bat @"
@echo off
setlocal
SET CYGWIN=%CYGWIN% nodosfilewarning

$($env:SYSTEMDRIVE)\cygwin\bin\$link.exe %*

endlocal
"@    
    
}
