$DistroName = "Ubuntu-22.04"
$InstallFolder = "${env:USERPROFILE}\.wsl\$DistroName"

if (-not (Test-Path $InstallFolder)) {
  Write-Output "Downloading and installing $DistroName..."

  New-Folder -Path $InstallFolder

  Download-File -Url "https://julianscorner.com/dl/folder-ubuntu.ico" `
    -Destination "$InstallFolder\folder-ubuntu.ico"

  Set-Content "$InstallFolder\desktop.ini" @"
[.ShellClassInfo]
IconResource=$InstallFolder\folder-ubuntu.ico,0
"@

  attrib.exe +S +H $InstallFolder\folder-ubuntu.ico
  attrib.exe +S +H $InstallFolder\desktop.ini
  attrib.exe +R $InstallFolder

  if (Test-Path "${env:TEMP}\Ubuntu.tar.gz") {
    Remove-Item -Path "${env:TEMP}\Ubuntu.tar.gz" -Force | Out-Null
  }

  $baseUrl = "https://cloud-images.ubuntu.com/wsl/jammy/current"
  $url = "$baseUrl/ubuntu-jammy-wsl-amd64-wsl.rootfs.tar.gz"

  Download-File -Url $url -Destination "${env:TEMP}\Ubuntu.tar.gz"

  $wsl = Invoke-Expression -Command "wsl.exe --list"

  if ($wsl.Contains($DistroName)) {
    Write-Warning "Found previously registered instance..."
    Invoke-Expression -Command "wsl.exe --unregister $DistroName"
  }

  Invoke-Expression -Command `
    "wsl.exe --import $DistroName `"$InstallFolder`" `"${env:TEMP}\ubuntu.tar.gz`""

  $ubuntu = "wsl.exe -d $DistroName"

  Invoke-Expression -Command `
    "$ubuntu /usr/sbin/adduser $($env:USERNAME) --gecos `"First,Last,RoomNumber,WorkPhone,HomePhone`" --disabled-password"

  Invoke-Expression -Command "$ubuntu /usr/sbin/usermod -aG sudo $($env:USERNAME)"

  Invoke-Expression -Command `
    "$ubuntu /bin/bash -c `"echo -e '$($env:USERNAME) ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/$($env:USERNAME)`""

  $keys = Get-ChildItem -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss"

  Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName `
    | Where-Object -Property DistributionName -eq $DistroName `
    | Set-ItemProperty -Name DefaultUid -Value "1000"

  Invoke-Expression -Command "$ubuntu /bin/bash -c `"curl -sSL https://julianscorner.com/dl/l/init-wsl.sh | bash`""

  Remove-Item -Path "${env:TEMP}\Ubuntu.tar.gz" -Force

  Invoke-Expression -Command "wsl.exe --setdefault $DistroName"
} else {
  Write-Output "A version of Ubuntu is already installed. Not overwriting the installed version..."
}
