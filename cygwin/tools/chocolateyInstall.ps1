$packageName = "cygwin"
$url = "http://cygwin.com/setup-x86.exe"
$url64 = "http://cygwin.com/setup-x86_64.exe"
$cygwinMirror = "http://mirrors.kernel.org/sourceware/cygwin"
$cygwinSetupDir = "$appDir\setup"

$appDir = "$($env:SystemDrive)\$($packageName)"

$upgrade = $false

if (Test-Path $appDir)
{
    # Check to see if the Cygwin package was installed via chocolatey
    $package = (Get-ChildItem "$($env:ChocolateyInstall)\lib" | Select-Object basename).basename `
        | Where-Object { $_.StartsWith($packageName) }

    if ($package.Count -gt 1) {
        Write-Warning "This package has already been installed, will attempt to upgrade..."
        $upgrade = $true
    } else {
        throw "Cygwin appears to already be installed on this system but not by this packaging system... Removed the Cygwin directory and try again."
    }
}

if (-not $upgrade) {
    New-Item $appDir -Type Directory

    Invoke-ElevatedCommand "cmd.exe" `
        -ArgumentList "/c mklink /J '$env:SYSTEMDRIVE\cygwin\home' '$env:SYSTEMDRIVE\Users'" `
        -Wait
}

if (-not (Test-Path $cygwinSetupDir)) {
    New-Item $cygwinSetupDir -Type Directory
}

if (Test-Path "$cygwinSetupDir\setup.exe") {
    Remove-Item "$cygwinSetupDir\setup.exe" -Force
}

if ([System.IntPtr]::Size -ne 4) {
    $url = $url64
}

Download-File $url "$cygwinSetupDir\setup.exe"

$cygwinSetupArgs = "--root $appDir --no-admin --no-shortcuts --site $cygwinMirror --quiet-mode"

Push-Location $cygwinSetupDir

cmd.exe /c "setup.exe $($cygwinSetupArgs)"

if (-not $upgrade) {
    cmd.exe /c "setup.exe $($cygwinSetupArgs) -P bcrypt"
    cmd.exe /c "setup.exe $($cygwinSetupArgs) -P curl"
    cmd.exe /c "setup.exe $($cygwinSetupArgs) -P dos2unix"
    cmd.exe /c "setup.exe $($cygwinSetupArgs) -P rxvt"
    cmd.exe /c "setup.exe $($cygwinSetupArgs) -P rsync"
    cmd.exe /c "setup.exe $($cygwinSetupArgs) -P openssh"
    cmd.exe /c "setup.exe $($cygwinSetupArgs) -P nc"
    cmd.exe /c "setup.exe $($cygwinSetupArgs) -P nc6"
    cmd.exe /c "setup.exe $($cygwinSetupArgs) -P ncurses"
    cmd.exe /c "setup.exe $($cygwinSetupArgs) -P inetutils"
    cmd.exe /c "setup.exe $($cygwinSetupArgs) -P util-linux"
    cmd.exe /c "setup.exe $($cygwinSetupArgs) -P unzip"
    cmd.exe /c "setup.exe $($cygwinSetupArgs) -P wget"
    cmd.exe /c "setup.exe $($cygwinSetupArgs) -P zip"

    Write-Output "Generating User Account Entries..."

    if (Test-Path $appDir\etc\passwd) {
        Remove-Item "$appDir\etc\passwd" -Force
    }

    cmd.exe /c "$appDir\bin\mkpasswd.exe -l -d > $appDir\etc\passwd"

    Write-Output "Generating Group Entries..."

    if (Test-Path $appDir\etc\group) {
        Remove-Item "$appDir\etc\group" -Force
    }

    cmd.exe /c "$appDir\bin\mkgroup.exe -l -d > $appDir\etc\group"
}

Pop-Location

Invoke-ElevatedScript {
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

    Function make-filelink ($filename) {
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
    "zip")

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
}
