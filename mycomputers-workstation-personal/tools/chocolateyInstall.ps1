$psremote = ([bool](Invoke-Command -ComputerName $env:COMPUTERNAME `
    -ScriptBlock {IPConfig} -ErrorAction SilentlyContinue))

$hyperv = (Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V).State -eq "Enabled"

$containers = (Get-WindowsOptionalFeature -Online -FeatureName Containers).State -eq "Enabled"

$wsl = (Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux).State -eq "Enabled"

if (-not $psremote) {
    Enable-PSRemoting -Force
}

if (-not $hyperv) {
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
}

if (-not $containers) {
    Enable-WindowsOptionalFeature -Online -FeatureName Containers -All -NoRestart
}

if (-not $wsl) {
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart

    Write-Warning "You must reboot before using the Linux Subsystem..."
}

Write-Output " Installing SearchMyFiles manually since the community package hasn't been updated..."

$url = 'http://www.nirsoft.net/utils/searchmyfiles-x64.zip'
$url64 = 'http://www.nirsoft.net/utils/searchmyfiles-x64.zip'

Set-Content -Path "$installFile.gui" -Value $null

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installFile = Join-Path $toolsDir "searchmyfiles.exe"

Install-ChocolateyZipPackage -PackageName "searchmyfiles" `
                             -Url "$url" `
                             -UnzipLocation "$toolsDir" `
                             -Url64bit "$url64"

if (-not (Test-Path $env:SYSTEMDRIVE\Ubuntu)) {
    Write-Output "Downloading and installing Ubuntu 18.04 ..."

    if (Test-Path $env:TEMP\ubuntu.appx) {
        Remove-Item -Path $env:TEMP\ubuntu.appx -Force | Out-Null
    }
    
    if (Test-Path $env:TEMP\ubuntu.zip) {
        Remove-Item -Path $env:TEMP\ubuntu.zip -Force | Out-Null
    }

    Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile $env:TEMP\Ubuntu.appx -UseBasicParsing

    Rename-Item $env:TEMP\Ubuntu.appx $env:TEMP\Ubuntu.zip

    New-Item -Type Directory -Path $env:SYSTEMDRIVE\Ubuntu | Out-Null

    Expand-Archive $env:TEMP\Ubuntu.zip $env:SYSTEMDRIVE\Ubuntu

    Set-Content $env:SYSTEMDRIVE\Ubuntu\desktop.ini @"
    [.ShellClassInfo]
    IconResource=$env:SYSTEMDRIVE\Ubuntu\ubuntu1804.exe,0
"@

    attrib +S +H $env:SYSTEMDRIVE\Ubuntu\desktop.ini
    attrib +S $env:SYSTEMDRIVE\Ubuntu

    Remove-Item -Path $env:TEMP\ubuntu.zip -Force | Out-Null
}
