$packageName = "myvm-development"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try { 
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
        
        Write-Warning "After configuring BTSync, The computer will need to restart..."
        
        $shell = New-Object -ComObject WScript.Shell
        $b = $shell.PopUp("Press the OK button when BTSync finishes synchronization.", 0, "Inital Setup Complete", 0)
    }

    Get-AppxProvisionedPackage -Online | Remove-AppxProvisionedPackage -Online | Out-Null
    Get-AppxPackage | Remove-AppxPackage -ea Silent

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
