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

$url = "http://www.nirsoft.net/utils/searchmyfiles.zip"
$url64 = "http://www.nirsoft.net/utils/searchmyfiles-x64.zip"
$installFile = Join-Path $PSScriptRoot "searchmyfiles.exe"

Install-ChocolateyZipPackage -PackageName "searchmyfiles" -Url $url -url64 $url64 -UnzipLocation $PSScriptRoot

Set-Content -Path "$installFile.gui" -Value $null
