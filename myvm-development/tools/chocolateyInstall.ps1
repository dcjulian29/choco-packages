$packageName = "myvm-development"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Function Read-MultiLineInput([string]$Message) {
    Add-Type -AssemblyName System.Drawing
    Add-Type -AssemblyName System.Windows.Forms
     
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Size(10,10) 
    $label.Size = New-Object System.Drawing.Size(280,20)
    $label.AutoSize = $true
    $label.Text = $Message
     
    $textBox = New-Object System.Windows.Forms.TextBox 
    $textBox.Location = New-Object System.Drawing.Size(10,40) 
    $textBox.Size = New-Object System.Drawing.Size(575,200)
    $textBox.AcceptsReturn = $true
    $textBox.AcceptsTab = $false
    $textBox.Multiline = $true
    $textBox.ScrollBars = 'Both'
     
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Size(415,250)
    $okButton.Size = New-Object System.Drawing.Size(75,25)
    $okButton.Text = "OK"
    $okButton.Add_Click({ $form.Tag = $textBox.Text; $form.Close() })
     
    $form = New-Object System.Windows.Forms.Form 
    $form.Size = New-Object System.Drawing.Size(610,320)
    $form.FormBorderStyle = 'FixedSingle'
    $form.StartPosition = "CenterScreen"
    $form.AutoSizeMode = 'GrowAndShrink'
    $form.Topmost = $True
    $form.AcceptButton = $okButton
    $form.ShowInTaskbar = $false
     
    $form.Controls.Add($label)
    $form.Controls.Add($textBox)
    $form.Controls.Add($okButton)
     
    $form.Add_Shown({$form.Activate()})
    $form.ShowDialog() > $null

    return $form.Tag
}

if (-not (Test-Path "${env:SYSTEMDRIVE}\home\vm\.stfolder")) {
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
        cmd /c "mklink /D etc ${env:SYSTEMDRIVE}\home\vm\etc"
    } else {
        Start-ChocolateyProcessAsAdmin "cmd /c mklink /D etc ${env:SYSTEMDRIVE}\home\vm\etc"
    }

    Pop-Location

    cmd /c "attrib +S ${env:SYSTEMDRIVE}\home"

    Remove-Item -Path "${env:SYSTEMDRIVE}\home\vm\*" -Recurse -Force
    
    # I don't want to put my "SyncThing IDs" in a public source control, so prompt for them.
    $ClientID = Read-Host "Enter the ID for this client"
    $ServerID = Read-Host "Enter the ID for this server"
    $Server = Read-Host "Enter the name of the central server"
    $Key = Read-MultiLineInput "Enter the certificate key"
    $Cert = Read-MultiLineInput "Enter the certificate"
    $ApiKey = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 32 | % {[char]$_})

    if (-not (Test-Path "$env:LOCALAPPDATA\Syncthing")) {
        New-Item -Path "$env:LOCALAPPDATA\Syncthing" -ItemType Directory | Out-Null
    }

    Set-Content -Path "$env:LOCALAPPDATA\Syncthing\config.xml" -Value @"
<configuration version="15">
    <folder id="vm" label="" path="c:\home\vm" type="readwrite" rescanIntervalS="60" ignorePerms="false" autoNormalize="true">
        <device id="$ClientID"></device>
        <device id="$ServerID"></device>
        <minDiskFreePct>1</minDiskFreePct>
        <versioning type="staggered">
            <param key="cleanInterval" val="3600"></param>
            <param key="maxAge" val="31536000"></param>
            <param key="versionsPath" val=""></param>
        </versioning>
        <copiers>0</copiers>
        <pullers>0</pullers>
        <hashers>0</hashers>
        <order>random</order>
        <ignoreDelete>false</ignoreDelete>
        <scanProgressIntervalS>0</scanProgressIntervalS>
        <pullerSleepS>0</pullerSleepS>
        <pullerPauseS>0</pullerPauseS>
        <maxConflicts>10</maxConflicts>
        <disableSparseFiles>false</disableSparseFiles>
        <disableTempIndexes>false</disableTempIndexes>
    </folder>
    <device id="$ClientID" name="$env:COMPUTERNAME" compression="metadata" introducer="false">
        <address>dynamic</address>
    </device>
    <device id="$ServerID" name="$($Server.ToUpper())" compression="metadata" introducer="false">
        <address>tcp://$($Server.ToLower()).julianscorner.com:22000</address>
    </device>
    <gui enabled="true" tls="false">
        <address>127.0.0.1:8384</address>
        <apikey>$ApiKey</apikey>
        <theme>default</theme>
    </gui>
    <options>
        <listenAddress>default</listenAddress>
        <globalAnnounceServer>default</globalAnnounceServer>
        <globalAnnounceEnabled>false</globalAnnounceEnabled>
        <localAnnounceEnabled>false</localAnnounceEnabled>
        <localAnnouncePort>21027</localAnnouncePort>
        <localAnnounceMCAddr>[ff12::8384]:21027</localAnnounceMCAddr>
        <maxSendKbps>0</maxSendKbps>
        <maxRecvKbps>0</maxRecvKbps>
        <reconnectionIntervalS>60</reconnectionIntervalS>
        <relaysEnabled>false</relaysEnabled>
        <relayReconnectIntervalM>10</relayReconnectIntervalM>
        <startBrowser>true</startBrowser>
        <natEnabled>true</natEnabled>
        <natLeaseMinutes>60</natLeaseMinutes>
        <natRenewalMinutes>30</natRenewalMinutes>
        <natTimeoutSeconds>10</natTimeoutSeconds>
        <urAccepted>0</urAccepted>
        <urUniqueID></urUniqueID>
        <urURL>https://data.syncthing.net/newdata</urURL>
        <urPostInsecurely>false</urPostInsecurely>
        <urInitialDelayS>1800</urInitialDelayS>
        <restartOnWakeup>true</restartOnWakeup>
        <autoUpgradeIntervalH>12</autoUpgradeIntervalH>
        <keepTemporariesH>24</keepTemporariesH>
        <cacheIgnoredFiles>false</cacheIgnoredFiles>
        <progressUpdateIntervalS>5</progressUpdateIntervalS>
        <symlinksEnabled>true</symlinksEnabled>
        <limitBandwidthInLan>false</limitBandwidthInLan>
        <minHomeDiskFreePct>1</minHomeDiskFreePct>
        <releasesURL>https://upgrades.syncthing.net/meta.json</releasesURL>
        <overwriteRemoteDeviceNamesOnConnect>false</overwriteRemoteDeviceNamesOnConnect>
        <tempIndexMinBlocks>10</tempIndexMinBlocks>
    </options>
</configuration>
"@

    Set-Content -Path "$env:LOCALAPPDATA\Syncthing\cert.pem" -Value $Cert
    Set-Content -Path "$env:LOCALAPPDATA\Syncthing\key.pem" -Value $Key

    Start-Process -FilePath "$env:SYSTEMDRIVE\tools\apps\syncthing\syncthing.exe" `
        -ArgumentList "-no-console -no-browser"
    
    Write-Output "Waiting for enough of the initial synchronization to occur..."

    while (-not (Test-Path "${env:SYSTEMDRIVE}\home\vm\etc\executor\executor.ini")) {
        Start-Sleep -Seconds 5
    }
    
    Write-Output "Found what I'm looking for... :)"
}

Write-Output "Installing .Net 3.x Framework..."

Enable-WindowsOptionalFeature -All -FeatureName NetFx3 -Online -Verbose

Write-Output "Installing Windows Container Support..."

Enable-WindowsOptionalFeature -All -FeatureName Containers -Online -Verbose -NoRestart

Get-AppxProvisionedPackage -Online | Remove-AppxProvisionedPackage -Online | Out-Null
Get-AppxPackage | Remove-AppxPackage -ErrorAction Silent

Write-Output "Searching for Windows Updates..."

$Criteria = "IsInstalled=0"
$Searcher = New-Object -ComObject Microsoft.Update.Searcher

$SearchResult = $Searcher.Search($Criteria).Updates
if ($SearchResult.Count -eq 0) {
    Write-Output "There are no applicable updates."
    exit
} else {
    $SearchResult | For-Each-Object { Write-Output " * $($_.Title)" }
    
    #$Session = New-Object -ComObject Microsoft.Update.Session
    #$Downloader = $Session.CreateUpdateDownloader()
    #$Downloader.Updates = $SearchResult
    #Write-Output "Downloading Updates..."
    #$Downloader.Download() | Out-Null
    #Write-Output "Installing Updates..."
    #$Installer = New-Object -ComObject Microsoft.Update.Installer
    #$Installer.Updates = $SearchResult
    #$Result = $Installer.Install()
}

