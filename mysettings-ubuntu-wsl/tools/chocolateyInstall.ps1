if (-not (Test-Path $env:SYSTEMDRIVE\Ubuntu\rootfs)) {
    Write-Output "Ubuntu Linux has been installed...  Starting final install."

    $ubuntu = Get-ChildItem -Path $env:SYSTEMDRIVE\Ubuntu `
        | Where-Object { $_.Name -match "^ubuntu\d+\.exe$" } `
        | Sort-Object Name -Descending `
        | Select-Object -First 1

    Start-Process -FilePath $ubuntu -ArgumentList "install --root" -NoNewWindow -Wait

    Start-Process -FilePath $ubuntu `
        -ArgumentList "run adduser $($env:USERNAME) --gecos ""First,Last,RoomNumber,WorkPhone,HomePhone"" `
        --disabled-password" -NoNewWindow -Wait

    Start-Process -FilePath $ubuntu `
        -ArgumentList "run usermod -aG sudo $($env:USERNAME)" -NoNewWindow -Wait

    Start-Process -FilePath $ubuntu `
        -ArgumentList "run echo '$($env:USERNAME) ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo" `
        -NoNewWindow -Wait

    Start-Process -FilePath $ubuntu `
        -ArgumentList "config --default-user $($env:USERNAME)" -NoNewWindow -Wait

    Start-Process -FilePath $ubuntu `
        -ArgumentList "run curl -sSL http://dl.julianscorner.com/l/init.sh | bash" -NoNewWindow -Wait
} else {
    Write-Output "Ubuutu is already installed and configured. Not overwriting the installed version..."
}
