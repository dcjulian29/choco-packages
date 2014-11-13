$packageName = "myvm-development"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try { 
    if (-not (Test-Path "${env:SYSTEMDRIVE}\home\vm\.SyncID")) {
        if (-not (Test-Path "${env:SYSTEMDRIVE}\home\vm"))
        {
            New-Item -Type Directory -Path "${env:SYSTEMDRIVE}\home\vm" | Out-Null

            if (-not (Test-Path "${env:SYSTEMDRIVE}\home\vm\etc"))
            {
                New-Item -Type Directory -Path "${env:SYSTEMDRIVE}\home\vm\etc" | Out-Null
            }
        }
        
        if (Test-Path "${env:SYSTEMDRIVE}\etc") {
            # Test if etc is already SYMLINKD to the "home" etc            
            New-Item -ItemType File -Path "${env:SYSTEMDRIVE}\etc\${env:COMPUTERNAME}-${env:USERNAME}.txt"
            
            if (Test-Path "${env:SYSTEMDRIVE}\home\vm\etc\${env:COMPUTERNAME}-${env:USERNAME}.txt") {
                cmd /c "rmdir ${env:SYSTEMDRIVE}\etc"
            } else {
                Remove-Item "${env:SYSTEMDRIVE}\etc" -Recurse -Force
            }
        }

        cmd /c "attrib -S ${env:SYSTEMDRIVE}\home"
        Push-Location "${env:SYSTEMDRIVE}\"

        if (Test-ProcessAdminRights) {
            Start-Process -NoNewWindow -Wait "cmd /c mklink.exe /D etc ${env:SYSTEMDRIVE}\home\vm\etc"
        } else {
            Start-ChocolateyProcessAsAdmin "cmd /c mklink /D etc ${env:SYSTEMDRIVE}\home\vm\etc"
        }

        Pop-Location

        cmd /c "attrib +S ${env:SYSTEMDRIVE}\home"

        Remove-Item -Path "${env:SYSTEMDRIVE}\home\vm\*" -Recurse -Force
        
        if (Get-ProcessorBits -eq 64) {
            & "${env:ProgramFiles(x86)}\BitTorrent Sync\BTSync.exe"
        } else {
            & "$($env:ProgramFiles)\BitTorrent Sync\BTSync.exe"    
        }
        
        Write-Warning "Waiting for BTSync configuration..."

        while (-not (Test-Path "${env:SYSTEMDRIVE}\home\vm\.sync")) {
            Start-Sleep -Seconds 1
        }

        Write-Output "Found VM BTSync directory, waiting for synchronization..."

        while (-not (Test-Path "${env:SYSTEMDRIVE}\home\vm\network.cmd")) {
            Start-Sleep -Seconds 5
        }

        Write-Output "Synchronization Started/Finished..."

        Start-Sleep -Seconds 30
    }

    Get-AppxProvisionedPackage -Online | Remove-AppxProvisionedPackage -Online
    Get-AppxPackage | Remove-AppxPackage -ErrorAction Silent

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
