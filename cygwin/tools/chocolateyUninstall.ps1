$packageName = "cygwin"
$appDir = "$($env:SYSTEMDRIVE)\$($packageName)"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

try
{
    if (Test-Path $appDir)
    {
        $remove = "Remove-Item '$($appDir)' -Recurse -Force"
        Start-ChocolateyProcessAsAdmin $remove
    
        $cmd = "reg.exe import $toolDir\registry.reg"
        
        if (Test-ProcessAdminRights) {
            Invoke-Expression $cmd
        } else {
            Start-ChocolateyProcessAsAdmin "$cmd"
        }

        if (Get-ProcessorBits -eq 64) {
            $cmd = "$cmd /reg:64"
            if (Test-ProcessAdminRights) {
                Invoke-Expression $cmd
            } else {
                Start-ChocolateyProcessAsAdmin "$cmd"
            }
        }
    }

    if (Test-Path "$($env:USERPROFILE)\.ssh") {
        (Get-Item "$($env:USERPROFILE)\.ssh").Delete()
    }

    (Get-Item "$($env:USERPROFILE)\.bash_history").Delete()
    (Get-Item "$($env:USERPROFILE)\.bash_logout").Delete()
    (Get-Item "$($env:USERPROFILE)\.bash_profile").Delete()
    (Get-Item "$($env:USERPROFILE)\.bashrc").Delete()
    (Get-Item "$($env:USERPROFILE)\.inputrc").Delete()
    (Get-Item "$($env:USERPROFILE)\.minttyrc").Delete()
    (Get-Item "$($env:USERPROFILE)\.profile").Delete()
    (Get-Item "$($env:USERPROFILE)\.Xresources").Delete()

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
    "hostname"
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
        (Get-Item "${env:ChocolateyInstall}\bin\$link.bat").Delete()
    }

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
