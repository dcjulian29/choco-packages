Get-Process | Where-Object { $_.ProcessName -eq "Docker Desktop" } | Stop-Process -Force

# I accept the Docker Desktop Agreement and License
& '$($env:ProgramFiles)\Docker\Docker\Docker Desktop.exe' -AcceptLicense
