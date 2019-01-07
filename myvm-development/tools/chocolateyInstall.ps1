$packageName = "myvm-development"

$ErrorActionPreference = "Stop"

if (Test-Path "$env:SYSTEMDRIVE\etc\logs\zzz.log") {
    write-Warning "Package already installed, no need to upgrade..."
    exit
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
    if (-not (Test-Path "${env:SYSTEMDRIVE}\home\vm")) {
        New-Item -Type Directory -Path "${env:SYSTEMDRIVE}\home\vm" | Out-Null
    }

    $rootPath = "${env:SystemRoot}\Setup\Scripts"
    $c = "$rootPath\${env:COMPUTERNAME}"
    if (Test-Path "$rootPath\server.id") {
        $ClientID = Get-Content "$c.id"
        $ServerID = Get-Content "$rootPath\server.id"
        $Server = Get-Content "$rootPath\server.name"
        $Key = Get-Content "$c.key"
        $Cert = Get-Content "$c.cert"
    } else {    
        $ClientID = Read-MultiLineInput "Enter the ID for this client"
        $ServerID = Read-MultiLineInput "Enter the ID for this server"
        $Server = Read-MultiLineInput "Enter the name of the central server"
        $Key = Read-MultiLineInput "Enter the certificate key"
        $Cert = Read-MultiLineInput "Enter the certificate"
    }

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

    Start-Process -FilePath "$env:ChocolateyInstall\bin\syncthing.exe" `
        -ArgumentList "-no-restart -no-browser"
    
    Write-Output "Waiting for enough of the initial synchronization to occur..."

    while (-not (Test-Path "${env:SYSTEMDRIVE}\home\vm\etc\executor\executor.ini")) {
        Start-Sleep -Seconds 5
        
        # Sometimes, Syncthing upgrades but does not restart...
        if (-not (Get-Process -Name "syncthing" -ea 0)) {
            Write-Output "Syncthing isn't currently running, starting the process..."
            
            Start-Process -FilePath "$env:ChocolateyInstall\bin\syncthing.exe" `
                -ArgumentList "-no-restart -no-browser"
        }
    }
    
    Write-Output "Found what I'm looking for... :)"
}

if (-not (Test-Path ${env:SYSTEMDRIVE}\etc)) {
    New-Item -ItemType Junction -Path ${env:SYSTEMDRIVE}\etc -Value ${env:SYSTEMDRIVE}\home\vm\etc
}

if (-not ((Get-Item ${env:SYSTEMDRIVE}\etc).Attributes -band [IO.FileAttributes]::ReparsePoint)) {
    Move-Item ${env:SYSTEMDRIVE}\etc ${env:SYSTEMDRIVE}\etc.bak
    New-Item -ItemType Junction -Path ${env:SYSTEMDRIVE}\etc -Value ${env:SYSTEMDRIVE}\home\vm\etc
}

Write-Output "Installing .Net 3.x Framework..."

Enable-WindowsOptionalFeature -All -FeatureName NetFx3 -Online

# Sometimes, Syncthing upgrades but does not restart...
if (-not (Get-Process -Name "syncthing" -ea 0)) {
    Write-Output "Syncthing isn't currently running, starting the process..."
    
    Start-Process -FilePath "$env:ChocolateyInstall\bin\syncthing.exe" `
        -ArgumentList "-no-restart -no-browser"
}

Write-Output "Waiting for log folder to sync..."

while (-not (Test-Path "$env:SYSTEMDRIVE\etc\logs\zzz.log")) {
    Start-Sleep -Seconds 5
}

Write-Output "Copying initial log files to sync folder..."

$files = @(
    "choco",
    "install",
    "SetupComplete"
)

foreach ($file in $files) {
    $date = Get-Date -Format "yyyyMMdd-hhmm"

    if (Test-Path "$env:WINDIR\Setup\Scripts\$file.log") {
        Copy-Item "$env:WINDIR\Setup\Scripts\$file.log" `
            "$env:SYSTEMDRIVE\etc\logs\$($env:COMPUTERNAME)-$file.$date.log" -Force
    }
}

$GoFolder = "$env:LOCALAPPDATA\Go-Shell"

New-Item -Type Directory -Path $GoFolder | Out-Null

Set-Content -Path "$GoFolder\go-shell-remember-last.txt" -Value ""
Set-Content -Path "$GoFolder\go-shell.txt" -Value @"
etc|C:\etc
documents|$env:USERPROFILE\documents
docs|$env:USERPROFILE\documents
pictures|$env:USERPROFILE\pictures
pics|$env:USERPROFILE\pictures
videos|$env:USERPROFILE\videos
desktop|$env:USERPROFILE\desktop
downloads|$env:USERPROFILE\downloads
"@

Write-Output "Initial Setup of Development VM Finished. Rebooting in 30 seconds..."

Start-Sleep -Seconds 30

Restart-Computer -Force
