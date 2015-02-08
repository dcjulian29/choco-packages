$packageName = "cygwin"
$url = "http://cygwin.com/setup-x86.exe"
$url64 = "http://cygwin.com/setup-x86_64.exe"
$cygwinMirror = "http://mirrors.kernel.org/sourceware/cygwin"

$appDir = "$($env:SystemDrive)\$($packageName)"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

$cygwinSetupDir = "$appDir\setup"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
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

        if (Test-ProcessAdminRights) {
            cmd /c mklink /J "$env:SYSTEMDRIVE\cygwin\home" "$env:SYSTEMDRIVE\Users"
        } else {
            Start-ChocolateyProcessAsAdmin "cmd /c mklink /J '$env:SYSTEMDRIVE\cygwin\home' '$env:SYSTEMDRIVE\Users'"
        }
    }

    if (-not (Test-Path $cygwinSetupDir)) {
        New-Item $cygwinSetupDir -Type Directory
    }

    if (Test-Path "$cygwinSetupDir\setup.exe") {
        Remove-Item "$cygwinSetupDir\setup.exe" -Force
    }

    Get-ChocolateyWebFile $packageName "$cygwinSetupDir\setup.exe" $url $url64

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

    if (Test-ProcessAdminRights) {
        . $toolDir\postInstall.ps1
    } else {
        Start-ChocolateyProcessAsAdmin ". $toolDir\postInstall.ps1"
    }
    

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
