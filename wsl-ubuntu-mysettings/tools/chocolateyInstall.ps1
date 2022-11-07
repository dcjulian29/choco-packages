if (-not (Test-Path $env:SYSTEMDRIVE\Ubuntu\ext4.vhdx)) {
  Write-Output "Ubuntu Linux has been installed...  Starting configuration..."

  $ubuntu = (Get-ChildItem -Path $env:SYSTEMDRIVE\Ubuntu `
    | Where-Object { $_.Name -match "^ubuntu\d\.exe$" } `
    | Sort-Object Name -Descending `
    | Select-Object -First 1).FullName

  if ($null -eq $ubuntu) {
    $ubuntu = "${env:SYSTEMDRIVE}\Ubuntu.exe"
  }

  if (-not (Test-Path -Path $ubuntu)) {
    throw "Unable to configure becuase '$ubuntu' is not present."
  }

  Start-Process -FilePath $ubuntu -ArgumentList "install --root" -NoNewWindow -Wait

  Start-Process -FilePath $ubuntu `
    -ArgumentList "run curl -sSL https://julianscorner.com/dl/l/init-wsl.sh | bash" -NoNewWindow -Wait

  $argument = "run adduser $($env:USERNAME) --gecos `"First,Last,RoomNumber,WorkPhone,HomePhone`" --disabled-password"
  Start-Process -FilePath $ubuntu -ArgumentList $argument -NoNewWindow -Wait

  Start-Process -FilePath $ubuntu `
    -ArgumentList "run usermod -aG sudo $($env:USERNAME)" -NoNewWindow -Wait

  Start-Process -FilePath $ubuntu `
    -ArgumentList "run echo '$($env:USERNAME) ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/$($env:USERNAME)" `
    -NoNewWindow -Wait

  Start-Process -FilePath $ubuntu `
    -ArgumentList "config --default-user $($env:USERNAME)" -NoNewWindow -Wait
} else {
  Write-Output "Ubuntu is already installed and configured. Not overwriting the installed version..."
}

Import-Module "${env:USERPROFILE}\Documents\WindowsPowerShell\Modules\go\go.psm1"

gd -Key "ubuntu" -delete
gd -Key "ubuntu" -SelectedPath "\\wsl$\Ubuntu-22.04" -add
