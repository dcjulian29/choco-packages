if (-not (Test-Path $env:SYSTEMDRIVE\Ubuntu)) {
  Write-Output "Downloading and installing Ubuntu 22.04 ..."

  New-Item -Type Directory -Path $env:SYSTEMDRIVE\Ubuntu | Out-Null

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

  Set-Content $env:SYSTEMDRIVE\Ubuntu\desktop.ini @"
[.ShellClassInfo]
IconResource=$env:SYSTEMDRIVE\Ubuntu\ubuntu2204.exe,0
"@

  attrib +S +H $env:SYSTEMDRIVE\Ubuntu\desktop.ini
  attrib +S $env:SYSTEMDRIVE\Ubuntu

  Remove-Item -Path $env:TEMP\ubuntu.zip -Force | Out-Null
  Remove-Item -Path $env:TEMP\ubuntu -Recurse -Force | Out-Null
} else {
  Write-Output "A version of Ubuntu is already installed. Not overwriting the installed version..."
}
