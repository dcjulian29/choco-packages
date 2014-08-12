$packageName = "myvm-development"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    Start-Transcript "$($env:TEMP)\myvm-development-transcript.log" -Append

    $packages = @(
        "mysettings-devwallpaper",
        "myscripts-development",
        "devvm-powershell",
        "devvm-scm",
        "devvm-buildtools",
        "devvm-visualstudio",
        "devvm-tools",
        "devvm-nodejs",
        "devvm-database",
        "btsync")

    $devvmpackage = (Get-ChildItem "$($env:ChocolateyInstall)\lib" | Select-Object basename).basename `
        | Where-Object { $_.StartsWith("myvm-development") }

    if ($package.Count -gt 1) {
        Write-Warning "This package has already been installed, attempting to upgrade any dependent packages..."
        foreach ($package in $packages) {
            cup $package
        }
    } else {
        Write-Warning "This is the first time this package is install so assume no other packages have been installed..."
        foreach ($package in $packages) {
            cinst $package
        }
    }

    if (-not (Test-Path $env:SYSTEMDRIVE\home\projects))
    {
        New-Item -Type Directory -Path $env:SYSTEMDRIVE\home\projects | Out-Null
    }

    if (-not (Test-Path "$env:SYSTEMDRIVE\home\vm\.SyncID")) {
        if (-not (Test-Path $env:SYSTEMDRIVE\home\vm))
        {
            New-Item -Type Directory -Path $env:SYSTEMDRIVE\home\vm | Out-Null

            if (-not (Test-Path $env:SYSTEMDRIVE\home\vm\etc))
            {
                New-Item -Type Directory -Path $env:SYSTEMDRIVE\home\vm\etc | Out-Null
            }
        }
        
        if (Test-Path $env:SYSTEMDRIVE\etc) {
            # Test if etc is already SYMLINKD to the "home" etc            
            New-Item -ItemType File -Path $env:SYSTEMDRIVE\etc\$env:COMPUTERNAME-$env:USERNAME.txt
            
            if (Test-Path $env:SYSTEMDRIVE\home\vm\etc\$env:COMPUTERNAME-$env:USERNAME.txt) {
                cmd /c "rmdir $env:SYSTEMDRIVE\etc"
            } else {
                Remove-Item $env:SYSTEMDRIVE\etc -Recurse -Force
            }
        }

        cmd /c "attrib -S $($env:SYSTEMDRIVE)\home"
        Push-Location "$($env:SYSTEMDRIVE)\"
        echo "cmd /c mklink.exe /D etc $($env:SYSTEMDRIVE)\home\vm\etc"
        Start-ChocolateyProcessAsAdmin "cmd /c mklink /D etc $($env:SYSTEMDRIVE)\home\vm\etc"
        Pop-Location
        cmd /c "attrib +S $($env:SYSTEMDRIVE)\home"

        Remove-Item -Path "$($env:SYSTEMDRIVE)\home\vm\*" -Recurse -Force
        
        if (Get-ProcessorBits -eq 64) {
            & "${env:ProgramFiles(x86)}\BitTorrent Sync\BTSync.exe"
        } else {
            & "$($env:ProgramFiles)\BitTorrent Sync\BTSync.exe"    
        }
        
        Write-Warning "After configuring BTSync, Restart-Computer to get started developing! :)"
    }

    Stop-Transcript
  
    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
