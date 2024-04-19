$wsl = (Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux).State -eq "Enabled"

if (-not $wsl) {
  throw "WSL feature is not enabled"
}

if ([System.Environment]::OSVersion.Version.Build -ge 19041) {
  $vmp = (Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform).State -eq "Enabled"

  if (-not $vmp) {
    throw "Virtual Machine Platform feature is not enabled"
  }

  & wsl.exe --update
  & wsl.exe --set-default-version 2
}

$wsl = Test-Path -Path "\\wsl.localhost\Ubuntu-22.04"

if ($wsl) {
  Write-Warning "Found previously registered Ubuntu 22.04 instance..."
  Write-Output "Not overwriting the installed version..."
} else {
  Write-Output "Downloading and installing Ubuntu 22.04...`n"

  if (Test-Path "${env:TEMP}\Ubuntu.tar.gz") {
    Remove-Item -Path "${env:TEMP}\Ubuntu.tar.gz" -Force | Out-Null
  }

  $baseUrl = "https://cloud-images.ubuntu.com/wsl/jammy/current"
  $url = "$baseUrl/ubuntu-jammy-wsl-amd64-wsl.rootfs.tar.gz"

  Invoke-WebRequest $url -OutFile $env:TEMP\Ubuntu.tar.gz

  $InstallFolder = "$($env:USERPROFILE)\AppData\Local\Packages\Ubuntu"

  Invoke-Expression -Command `
    "wsl.exe --import Ubuntu-22.04 `"$InstallFolder`" `"${env:TEMP}\Ubuntu.tar.gz`""

  $exe = "wsl.exe -d Ubuntu-22.04"

  Invoke-Expression -Command `
    "$exe /usr/sbin/adduser $($env:USERNAME) --gecos `"First,Last,RoomNumber,WorkPhone,HomePhone`" --disabled-password"

  Invoke-Expression -Command "$exe /usr/sbin/usermod -aG sudo $($env:USERNAME)"

  Invoke-Expression -Command `
    "$exe /bin/bash -c `"echo -e '$($env:USERNAME) ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/$($env:USERNAME)`""

  Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName `
  | Where-Object -Property DistributionName -eq "Ubuntu-22.04" `
  | Set-ItemProperty -Name DefaultUid -Value "1000"

  & wsl.exe -d "Ubuntu-22.04" /bin/bash -c "curl -sSL https://julianscorner.com/dl/l/init-wsl.sh | bash"

  & wsl.exe --setdefault "Ubuntu-22.04"
}
