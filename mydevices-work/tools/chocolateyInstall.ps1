$baseDir = "${env:SYSTEMDRIVE}"
$homeDir = $(Join-Path -Path $baseDir -ChildPath "home")
$workDir = $(Join-Path -Path $homeDir -ChildPath "work")
$etcDir  = $(Join-Path -Path $workDir -ChildPath "etc")
$docsDir = $(Join-Path -Path $workDir -ChildPath "pics")
$picsDir = $(Join-Path -Path $workDir -ChildPath "pics")
$upDocs  = $(Join-Path -Path "${env:USERPROFILE}" -ChildPath "Documents")
$upPics  = $(Join-Path -Path "${env:USERPROFILE}" -ChildPath "Pictures")

if (-not (Test-Path $homeDir)) {
  New-Item -Path $homeDir -ItemType Directory | Out-Null
} else {
  Write-Warning "'$homeDir' alread exists... skipping."
}

if (-not (Test-Path $workDir)) {
  New-Item -Path $workDir -ItemType Directory | Out-Null
} else {
  Write-Warning "'$workDir' alread exists... skipping."
}

if (-not (Test-Path $etcDir)) {
  New-Item -Path $etcDir -ItemType Directory | Out-Null
} else {
  Write-Warning "'$etcDir' alread exists... skipping."
}

if (-not (Test-Path $docsDir)) {
  New-Item -Path $docsDir -ItemType Directory | Out-Null
} else {
  Write-Warning "'$docsDir' alread exists... skipping."
}

if (-not (Test-Path $picsDir)) {
  New-Item -Path $picsDir -ItemType Directory | Out-Null
} else {
  Write-Warning "'$picsDir' alread exists... skipping."
}

if (-not (Test-Path "$(Join-Path -Path $baseDir -ChildPath 'etc')")) {
  New-Item -ItemType SymbolicLink -Path  $baseDir -Name etc -Target $etcDir | Out-Null
  New-Item -ItemType SymbolicLink -Path  $upDocs -Name work -Target $docsDir | Out-Null
  New-Item -ItemType SymbolicLink -Path  $upPics -Name work -Target $picsDir | Out-Null
} else {
  Write-Warning "Work device home folders links already exists... not recreating!"
}

#------------------------------------------------------------------------------

gd -Key "desktop" -SelectedPath "$($env:USERPROFILE)\desktop" -add
gd -Key "downloads" -SelectedPath "$($env:USERPROFILE)\downloads" -add
gd -Key "documents" -SelectedPath "$($env:USERPROFILE)\documents" -add
gd -Key "pictures" -SelectedPath "$($env:USERPROFILE)\pictures" -add
gd -Key "videos" -SelectedPath "$($env:USERPROFILE)\videos" -add
gd -Key "work" -SelectedPath "${env:SYSTEMDRIVE}\home\work" -add

#------------------------------------------------------------------------------

Write-Output "`n`nExcluding Ports for Common Servers so the OS doesn't reserve them..."

if (Get-Process -Name "syncthing" -ea 0) {
  Get-Process -Name "syncthing" | Stop-Process -Force
}

Write-Output "# Web sites (8000-8099)"
netsh int ipv4 add excludedportrange protocol=tcp startport=8000 numberofports=100

Write-Output "# SyncThing"
netsh int ipv4 add excludedportrange protocol=tcp startport=8343 numberofports=1
netsh int ipv4 add excludedportrange protocol=tcp startport=22000 numberofports=1
netsh int ipv4 add excludedportrange protocol=udp startport=22000 numberofports=1

netsh int ipv4 show excludedportrange tcp
netsh int ipv4 show excludedportrange udp

#------------------------------------------------------------------------------

$hyperv = (Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V).State -eq "Enabled"
$containers = (Get-WindowsOptionalFeature -Online -FeatureName Containers).State -eq "Enabled"
$wsl = (Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux).State -eq "Enabled"

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

if ([System.Environment]::OSVersion.Version.Build -ge 19041) {
  $vmp = (Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform).State -eq "Enabled"

  if (-not $vmp) {
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart

    Write-Warning "You may need to reboot before using the Virtual Machine Platform..."
  }
} else {
  $build = "$([System.Environment]::OSVersion.Version.Build)"
  Write-Warning "WSL 2 is not available on this build of Windows: $build!"
}
