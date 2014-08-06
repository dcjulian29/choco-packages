$packageName = "myvm-development"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Start-Transcript "$($env:TEMP)\myvm-development-transcript.log" -Append

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
    cinst mysettings-pshellhere
    
    cinst java
    cinst pdfcreator
    cinst winpcap
    cinst sumatrapdf
    cinst keepass
    cinst 7zip
    cinst executor

    cinst git
    cinst gitflow
    cinst gittfs
    cinst posh-git
    cinst smartgit
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

    cinst nodejs    
    npm install -g csslint
    npm install -g jslint
    npm install -g jshint
    npm install -g node-inspector
    npm install -g typescript
    cinst atom
    
    cinst vsultimate
    cinst resharper
    cinst stylecop

    cinst mysettings-visualstudio
    cinst mysettings-vsix
    cinst mysettings-stylecop
    
    cinst webpi
    cinst webpicmd
    cinst -source webpi WebMatrixWeb
    cinst -source webpi WindowsAzureXPlatCLI
    cinst -source webpi WindowsAzurePowershell

    cinst xmind
    cinst dotpeek
    cinst expresso
    cinst linqpad
    cinst nant
    cinst nsis
    cinst octopusdeploy-tool

    cinst ravendb-server
    sc.exe config "RavenDb" start= demand
    cinst ravendb-backup
    cinst ravendb-smuggler
    
    cinst mongodb
    sc.exe config "MongoDb" start= demand
    cinst robomong
    
    cinst sqlserverexpress
    sc.exe config "MSSQL" start= demand
    cinst sqlmanagementstudio
    
    cinst mysql
    sc.exe config "MySql" start= demand
    cinst mysqlworkbench

    # Install Chrome    
    $chrome = "https://dl.google.com/tag/s/appguid={8A69D345-D564-463C-AFF1-A69D9E530F96}&iid={00000000-0000-0000-0000-000000000000}&lang=en&browser=3&usagestats=0&appname=Google%2520Chrome&needsadmin=prefers/edgedl/chrome/install/GoogleChromeStandaloneEnterprise.msi"
    Install-ChocolateyPackage "Chrome" "MSI" "/quiet" $chrome
    
    
    # Install Firefox
    $firefox = "https://download.mozilla.org/?product=firefox-31.0-SSL&os=win&lang=en-US"
    Install-ChocolateyPackage "Firefox" "EXE" "-ms" $firefox

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}

Stop-Transcript
