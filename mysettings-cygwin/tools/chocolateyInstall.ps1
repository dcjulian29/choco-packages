$packageName = "mysettings-cygwin"

$cygwin_root = (Get-ItemProperty 'HKLM:\SOFTWARE\Cygwin\setup' -ea 0).rootdir

if (Test-Path $cygwin_root\home) {
    Remove-Item $cygwin_root\home -Force
}

New-Junction -LiteralPath "$cygwin_root\home" -TargetPath "$env:SYSTEMDRIVE\Users"

Push-Location "$cygwin_root"

cmd.exe /c "cygwinsetup.exe --quiet-mode -P bcrypt"
cmd.exe /c "cygwinsetup.exe --quiet-mode -P curl"
cmd.exe /c "cygwinsetup.exe --quiet-mode -P dos2unix"
cmd.exe /c "cygwinsetup.exe --quiet-mode -P rxvt"
cmd.exe /c "cygwinsetup.exe --quiet-mode -P rsync"
cmd.exe /c "cygwinsetup.exe --quiet-mode -P openssh"
cmd.exe /c "cygwinsetup.exe --quiet-mode -P nc"
cmd.exe /c "cygwinsetup.exe --quiet-mode -P nc6"
cmd.exe /c "cygwinsetup.exe --quiet-mode -P ncurses"
cmd.exe /c "cygwinsetup.exe --quiet-mode -P inetutils"
cmd.exe /c "cygwinsetup.exe --quiet-mode -P util-linux"
cmd.exe /c "cygwinsetup.exe --quiet-mode -P unzip"
cmd.exe /c "cygwinsetup.exe --quiet-mode -P wget"
cmd.exe /c "cygwinsetup.exe --quiet-mode -P zip"

Write-Output "Generating User Account Entries..."

if (Test-Path $cygwin_root\etc\passwd) {
    Remove-Item "$cygwin_root\etc\passwd" -Force
}

cmd.exe /c "$cygwin_root\bin\mkpasswd.exe -l -d > $cygwin_root\etc\passwd"

Write-Output "Generating Group Entries..."

if (Test-Path $cygwin_root\etc\group) {
    Remove-Item "$cygwin_root\etc\group" -Force
}

cmd.exe /c "$cygwin_root\bin\mkgroup.exe -l -d > $cygwin_root\etc\group"

Pop-Location

Invoke-ElevatedScript {
    $etc = "$($env:SYSTEMDRIVE)\etc"
    $up = "$($env:USERPROFILE)"

    Function make-filelink ($filename) {
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
    "zip")

    foreach ($link in $links) {
        if (Test-Path "${env:ChocolateyInstall}\bin\$link.bat") {
            (Get-Item "${env:ChocolateyInstall}\bin\$link.bat").Delete()
        }

        Set-Content ${env:ChocolateyInstall}\bin\$link.bat @"
@echo off
setlocal
SET CYGWIN=%CYGWIN% nodosfilewarning

$cygwin_root\bin\$link.exe %*

endlocal
"@            
    }
}
