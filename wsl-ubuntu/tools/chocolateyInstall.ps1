if (-not (Test-Path $env:SYSTEMDRIVE\Ubuntu)) {
  Write-Output "Downloading and installing Ubuntu 22.04 ..."

  New-Item -Type Directory -Path $env:SYSTEMDRIVE\Ubuntu | Out-Null

  Invoke-WebRequest -Uri https://julianscorner.com/dl/folder-ubuntu.ico `
    -OutFile $env:SYSTEMDRIVE\Ubuntu\folder-ubuntu.ico -UseBasicParsing

  Set-Content $env:SYSTEMDRIVE\Ubuntu\desktop.ini @"
[.ShellClassInfo]
IconResource=$env:SYSTEMDRIVE\Ubuntu\folder-ubuntu.ico,0
"@

  attrib.exe +S +H $env:SYSTEMDRIVE\Ubuntu\folder-ubuntu.ico
  attrib.exe +S +H $env:SYSTEMDRIVE\Ubuntu\desktop.ini
  attrib.exe +R $env:SYSTEMDRIVE\Ubuntu

  if (Test-Path $env:TEMP\ubuntu.zip) {
    Remove-Item -Path $env:TEMP\ubuntu.zip -Force | Out-Null
  }

  if (Test-Path $env:TEMP\ubuntu) {
    Remove-Item -Path $env:TEMP\ubuntu -Recurse -Force | Out-Null
  }

  Invoke-WebRequest -Uri https://aka.ms/wslubuntu2204 `
    -OutFile $env:TEMP\Ubuntu.zip -UseBasicParsing

  Expand-Archive $env:TEMP\Ubuntu.zip $env:TEMP\Ubuntu\

  $package = (Get-ChildItem -Path $env:TEMP\Ubuntu\ `
      | Where-Object { $_.Name -match "^Ubuntu.+_x64\.appx$" } `
      | Sort-Object Name -Descending `
      | Select-Object -First 1).FullName

  Rename-Item $package $env:TEMP\Ubuntu\Ubuntu.zip

  Expand-Archive $env:TEMP\Ubuntu\Ubuntu.zip $env:SYSTEMDRIVE\Ubuntu

  Remove-Item -Path $env:TEMP\ubuntu.zip -Force | Out-Null
  Remove-Item -Path $env:TEMP\ubuntu -Recurse -Force | Out-Null

  $ubuntu = (Get-ChildItem -Path $env:SYSTEMDRIVE\Ubuntu `
    | Where-Object { $_.Name -match "^ubuntu\d+\.exe$" } `
    | Sort-Object Name -Descending `
    | Select-Object -First 1).FullName

  if ($null -eq $ubuntu) {
    $ubuntu = "${env:SYSTEMDRIVE}\Ubuntu\Ubuntu.exe"
  }

  if (-not (Test-Path -Path $ubuntu)) {
    throw "Unable to configure becuase '$ubuntu' is not present."
  }

  Start-Process -FilePath $ubuntu -ArgumentList "install --root" -NoNewWindow -Wait

  $argument = "run adduser $($env:USERNAME) --gecos `"First,Last,RoomNumber,WorkPhone,HomePhone`" --disabled-password"
  Start-Process -FilePath $ubuntu -ArgumentList $argument -NoNewWindow -Wait

  Start-Process -FilePath $ubuntu `
    -ArgumentList "run usermod -aG sudo $($env:USERNAME)" -NoNewWindow -Wait

  Start-Process -FilePath $ubuntu `
    -ArgumentList "run echo '$($env:USERNAME) ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/$($env:USERNAME)" `
  -NoNewWindow -Wait

  Start-Process -FilePath $ubuntu `
    -ArgumentList "config --default-user $($env:USERNAME)" -NoNewWindow -Wait

  Start-Process -FilePath $ubuntu `
    -ArgumentList "run curl -sSL https://julianscorner.com/dl/l/init-wsl.sh | bash" -NoNewWindow -Wait

  Add-FavoriteFolder -Key "ubuntu" -Path "\\wsl$\Ubuntu-22.04" -Force
} else {
  Write-Output "A version of Ubuntu is already installed. Not overwriting the installed version..."
}
