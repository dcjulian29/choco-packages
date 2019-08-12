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
    Enable-WindowsOptionalFeature -Online -FeatureName Containers -All
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

    Remove-Item -Path $env:TEMP\ubuntu.appx -Force | Out-Null
    Remove-Item -Path $env:TEMP\ubuntu.zip -Force | Out-Null

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

    Write-Output "Ubuntu Linux has been installed...  Starting final install."

    Start-Process -FilePath $env:SYSTEMDRIVE\Ubuntu\ubuntu1804.exe `
        -ArgumentList "install --root" -NoNewWindow -Wait

    Start-Process -FilePath $env:SYSTEMDRIVE\Ubuntu\ubuntu1804.exe `
        -ArgumentList "run adduser $($env:USERNAME) --gecos ""First,Last,RoomNumber,WorkPhone,HomePhone"" --disabled-password" -NoNewWindow -Wait

    Start-Process -FilePath $env:SYSTEMDRIVE\Ubuntu\ubuntu1804.exe `
        -ArgumentList "run usermod -aG sudo $($env:USERNAME)" -NoNewWindow -Wait

    Start-Process -FilePath $env:SYSTEMDRIVE\Ubuntu\ubuntu1804.exe `
        -ArgumentList "run echo '$($env:USERNAME) ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo" -NoNewWindow -Wait

    Start-Process -FilePath $env:SYSTEMDRIVE\Ubuntu\ubuntu1804.exe `
        -ArgumentList "config --default-user $($env:USERNAME)" -NoNewWindow -Wait

    Start-Process -FilePath $env:SYSTEMDRIVE\Ubuntu\ubuntu1804.exe `
        -ArgumentList "run curl -sSL http://dl.julianscorner.com/l/init.sh | bash" -NoNewWindow -Wait
}

Write-Output "Initialize MiniKube and configure its VM ..."

& minikube.exe config set vm-driver hyperv
& minikube.exe config set hyperv-virtual-switch "Default Switch"
& minikube.exe start
& minikube.exe ssh 'sudo poweroff'

Set-VMMemory -VMName "minikube" -DynamicMemoryEnabled $false
