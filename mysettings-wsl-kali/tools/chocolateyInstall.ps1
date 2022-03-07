if (-not (Test-Path $env:SYSTEMDRIVE\Kali\ext4.vhdx)) {
  Write-Output "Kali Linux has been installed...  Starting final install."

  $kali = (Get-ChildItem -Path $env:SYSTEMDRIVE\Kali `
    | Where-Object { $_.Name -match "^kali\.exe$" } `
    | Sort-Object Name -Descending `
    | Select-Object -First 1).FullName

  Start-Process -FilePath $kali -ArgumentList "install --root" -NoNewWindow -Wait

  Start-Process -FilePath $kali `
    -ArgumentList "run wget --no-check-certificate -nv -O - https://julianscorner.com/dl/l/init-kali.sh | bash" -NoNewWindow -Wait
} else {
  Write-Output "Ubuntu is already installed and configured. Not overwriting the installed version..."
}
