if (-not (Test-Path $env:SYSTEMDRIVE\Ubuntu)) {
  Write-Output "Downloading and installing Ubuntu 20.04 ..."

  New-Item -Type Directory -Path $env:SYSTEMDRIVE\Ubuntu | Out-Null

  if (Test-Path $env:TEMP\ubuntu.zip) {
    Remove-Item -Path $env:TEMP\ubuntu.zip -Force | Out-Null
  }

  if (Test-Path $env:TEMP\ubuntu) {
    Remove-Item -Path $env:TEMP\ubuntu -Recurse -Force | Out-Null
  }

  Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 `
    -OutFile $env:TEMP\Ubuntu.zip -UseBasicParsing

  Expand-Archive $env:TEMP\Ubuntu.zip $env:TEMP\Ubuntu\

  # Recently, the download link is an APPX bundle instead of the APPX file.
  if (Test-Path "${env:TEMP}\Ubuntu\ubuntu2004.exe") {
    Move-Item $env:TEMP\Ubuntu\* $env:SYSTEMDRIVE\Ubuntu
  } else {
    $package = (Get-ChildItem -Path $env:TEMP\Ubuntu\ `
        | Where-Object { $_.Name -match "^Ubuntu.+_x64\.appx$" } `
        | Sort-Object Name -Descending `
        | Select-Object -First 1).FullName

    Rename-Item $package $env:TEMP\Ubuntu\Ubuntu.zip

    Expand-Archive $env:TEMP\Ubuntu\Ubuntu.zip $env:SYSTEMDRIVE\Ubuntu

    if (-not (Test-Path "${env:TEMP}\Ubuntu\ubuntu2004.exe")) {
      New-Item -ItemType SymbolicLink -Path "${env:SYSTEMDRIVE}\Ubuntu\ubuntu2004.exe" `
        -Value "${env:SYSTEMDRIVE}\Ubuntu\ubuntu.exe" | Out-Null
    }
  }

  Set-Content $env:SYSTEMDRIVE\Ubuntu\desktop.ini @"
[.ShellClassInfo]
IconResource=$env:SYSTEMDRIVE\Ubuntu\ubuntu2004.exe,0
"@

  attrib +S +H $env:SYSTEMDRIVE\Ubuntu\desktop.ini
  attrib +S $env:SYSTEMDRIVE\Ubuntu

  Remove-Item -Path $env:TEMP\ubuntu.zip -Force | Out-Null
  Remove-Item -Path $env:TEMP\ubuntu -Recurse -Force | Out-Null
} else {
  Write-Output "A version of Ubuntu is already installed. Not overwriting the installed version..."
}
