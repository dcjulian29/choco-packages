$version     = "24.04"
$build       = "noble"
$version_old = "22.04"

$wsl = Test-Path -Path "\\wsl.localhost\Ubuntu-$version"

if ($wsl) {
  Write-Warning "Found previously registered Ubuntu $version instance..."
  Write-Output "Not overwriting the installed version..."
} else {
  Write-Output "Downloading and installing Ubuntu $version...`n"

  if (Test-Path "${env:TEMP}\Ubuntu.tar.gz") {
    Remove-Item -Path "${env:TEMP}\Ubuntu.tar.gz" -Force | Out-Null
  }

  $baseUrl = "https://cloud-images.ubuntu.com/wsl/$build/current"
  $url = "$baseUrl/ubuntu-$build-wsl-amd64-ubuntu.rootfs.tar.gz"

  Invoke-WebRequest $url -OutFile $env:TEMP\Ubuntu.tar.gz

  $InstallFolder = "$($env:USERPROFILE)\AppData\Local\Packages\Ubuntu\$version"

  Invoke-Expression -Command `
    "wsl.exe --import Ubuntu-$version `"$InstallFolder`" `"${env:TEMP}\Ubuntu.tar.gz`""

  $exe = "wsl.exe -d Ubuntu-$version"

  Invoke-Expression -Command `
    "$exe /usr/sbin/adduser $($env:USERNAME) --gecos `"First,Last,RoomNumber,WorkPhone,HomePhone`" --disabled-password"

  Invoke-Expression -Command "$exe /usr/sbin/usermod -aG sudo $($env:USERNAME)"

  Invoke-Expression -Command `
    "$exe /bin/bash -c `"echo -e '$($env:USERNAME) ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/$($env:USERNAME)`""

  Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName `
  | Where-Object -Property DistributionName -eq "Ubuntu-$version" `
  | Set-ItemProperty -Name DefaultUid -Value "1000"

  & wsl.exe -d "Ubuntu-$version" /bin/bash -c "curl -sSL https://julianscorner.com/dl/l/init-wsl.sh | bash"

  & wsl.exe --setdefault "Ubuntu-$version"

  if (Test-Path -Path "\\wsl.localhost\Ubuntu-$version_old") {
    & wsl.exe --unregister "Ubuntu-$version_old"
  }
}
