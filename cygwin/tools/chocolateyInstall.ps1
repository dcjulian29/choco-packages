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

    Start-ChocolateyProcessAsAdmin "setx /m TERM msys"

    if (-not $upgrade) {
        New-Item $appDir -Type Directory
        New-Item $appDir\home -Type Directory

        Start-ChocolateyProcessAsAdmin "cmd /c mklink /J '$env:SYSTEMDRIVE\cygwin\home\$env:USERNAME' '$env:USERPROFILE'"
    }

    if (-not (Test-Path $cygwinSetupDir)) {
        New-Item $cygwinSetupDir -Type Directory
    }

    Get-ChocolateyWebFile $packageName "$cygwinSetupDir\setup.exe" $url $url64

    $cygwinSetup = "cd $cygwinSetupDir ``& setup.exe"
    $cygwinSetupArgs = "--root '$appDir' --no-shortcuts --site $cygwinMirror --quiet-mode"

    cmd /c $cygwinSetup $cygwinSetupArgs

    if (-not $upgrade) {
        $cygwinPackage = "--root $appDir --no-admin --no-shortcuts --site $cygwinMirror --quiet-mode -P "

        Push-Location $cygwinSetupDir
        cmd.exe /c "setup.exe $($cygwinPackage) bcrypt"
        cmd.exe /c "setup.exe $($cygwinPackage) curl"
        cmd.exe /c "setup.exe $($cygwinPackage) rxvt"
        cmd.exe /c "setup.exe $($cygwinPackage) rsync"
        cmd.exe /c "setup.exe $($cygwinPackage) openssh"
        cmd.exe /c "setup.exe $($cygwinPackage) nc"
        cmd.exe /c "setup.exe $($cygwinPackage) nc6"
        cmd.exe /c "setup.exe $($cygwinPackage) ncurses"
        cmd.exe /c "setup.exe $($cygwinPackage) inetutils"
        cmd.exe /c "setup.exe $($cygwinPackage) util-linux"
        cmd.exe /c "setup.exe $($cygwinPackage) unzip"
        cmd.exe /c "setup.exe $($cygwinPackage) wget"
        cmd.exe /c "setup.exe $($cygwinPackage) zip"

        Pop-Location

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

    Start-ChocolateyProcessAsAdmin ". $toolDir\postInstall.ps1"

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
