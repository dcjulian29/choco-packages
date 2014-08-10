$packageName = "myvm-development"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Function Run-Package {
    try {
        if (-not (Test-Path $env:SYSTEMDRIVE\home\projects))
        {
            New-Item -Type Directory -Path $env:SYSTEMDRIVE\home\projects | Out-Null
        }

        if (-not (Test-Path $env:SYSTEMDRIVE\home\vm))
        {
            New-Item -Type Directory -Path $env:SYSTEMDRIVE\home\vm | Out-Null
        }

        if (-not (Test-Path $env:SYSTEMDRIVE\home\vm\etc))
        {
            New-Item -Type Directory -Path $env:SYSTEMDRIVE\home\vm\etc | Out-Null
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

        ##############################################################################################
        
        cinst mysettings-devwallpaper

        cinst myscripts-development
        cinst myscripts-powershell
        
        cinst java
        cinst pdfcreator
        cinst winpcap
        cinst sumatrapdf
        cinst keepass
        cinst 7zip
        cinst executor

        cinst xplorer2
        cinst mysettings-xplorer2
        
        cinst git
        cinst gitflow
        cinst gittfs
        cinst posh-git
        cinst tortoisegit
        cinst svn

        cinst nuget
        cinst nugetexplorer
        cinst baretail
        cinst kdiff
        cinst wmiexplorer
        cinst xmlquire
        cinst argouml
        cinst soapui
        cinst cygwin
        cinst bind-tools
        cinst python
        cinst searchmyfiles
        cinst wireshark
        cinst jperf
        cinst fiddler
        cinst regexbuilder

        cinst posh-go

        Import-Module go
        go -key "projects" -selectedPath "C:\home\projects" -add
        go -key "etc" -selectedPath "C:\home\vm\etc" -add
        go -key "home" -selectedPath "$($env:USERPROFILE)" -add
        go -key "downloads" -selectedPath "$($env:USERPROFILE)\Downloads" -add
        go -key "docs" -selectedPath "$($env:USERPROFILE)\Documents" -add
        go -key "documents" -selectedPath "$($env:USERPROFILE)\Documents" -add
        go -key "pics" -selectedPath "$($env:USERPROFILE)\Pictures" -add
        go -key "pictures" -selectedPath "$($env:USERPROFILE)\Pictures" -add
        go -key "videos" -selectedPath "$($env:USERPROFILE)\Videos" -add
        go -key "desktop" -selectedPath "$($env:USERPROFILE)\Desktop" -add
        
        cinst posh-psake

        
        cinst vsultimate
        cinst resharper
        cinst stylecop

        cinst mysettings-vsix
        cinst mysettings-stylecop
        
        cinst webpi
        cinst -source webpi WebMatrixWeb
        cinst -source webpi WindowsAzureXPlatCLI
        cinst -source webpi WindowsAzurePowershell
        cinst -source webpi VWDOrVs2013AzurePack.2.4

        cinst xmind
        cinst dotpeek
        cinst expresso
        cinst linqpad
        cinst nant
        cinst nsis
        cinst octopusdeploy-tool

        # Install Chrome    
        $chrome = "https://dl.google.com/tag/s/appguid={8A69D345-D564-463C-AFF1-A69D9E530F96}&iid={00000000-0000-0000-0000-000000000000}&lang=en&browser=3&usagestats=0&appname=Google%2520Chrome&needsadmin=prefers/edgedl/chrome/install/GoogleChromeStandaloneEnterprise.msi"
        Install-ChocolateyPackage "Chrome" "MSI" "/quiet" $chrome
        Start-ChocolateyProcessAsAdmin "Remove-Item '$($env:PUBLIC)\Desktop\Google Chrome.lnk' -Force"
        
        # Install Firefox
        $firefox = "https://download.mozilla.org/?product=firefox-31.0-SSL&os=win&lang=en-US"
        Install-ChocolateyPackage "Firefox" "EXE" "-ms" $firefox
        Start-ChocolateyProcessAsAdmin "Remove-Item '$($env:PUBLIC)\Desktop\Mozilla Firefox.lnk' -Force"

        
        Remove-Item -Path "$($env:SYSTEMDRIVE)\home\vm\*" -Recurse -Force
        
        if (Get-ProcessorBits -eq 64) {
            & "${env:ProgramFiles(x86)}\BitTorrent Sync\BTSync.exe"
        } else {
            & "$($env:ProgramFiles)\BitTorrent Sync\BTSync.exe"    
        }
        
        Write-Warning "After configuring BTSync, Restart-Computer to get started developing! :)"
        
        Write-ChocolateySuccess $packageName
    } catch {
        Write-ChocolateyFailure $packageName $($_.Exception.Message)
        throw
    }
}

#######################################################################################

Start-Transcript "$($env:TEMP)\myvm-development-transcript.log" -Append

$package = (Get-ChildItem "$($env:ChocolateyInstall)\lib" | Select-Object basename).basename `
    | Where-Object { $_.StartsWith("myvm-development") }

if ($package.Count -gt 1) {
    Write-Warning "This package has already been installed."
    Write-Warning "This package though upgraded is not designed to run multiple times."
    Write-Warning "Please review the differences between This package though upgraded is not designed to run multiple times."

    Write-ChocolateySuccess $packageName
} else {
    Run-Package
}

Stop-Transcript
