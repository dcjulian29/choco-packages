if (-not (Test-Path $env:SYSTEMDRIVE\Kali)) {
  Write-Output "Downloading and installing Kali Linux Rolling..."

  New-Item -Type Directory -Path $env:SYSTEMDRIVE\Kali | Out-Null

  if (Test-Path $env:TEMP\Kali.zip) {
    Remove-Item -Path $env:TEMP\Kali.zip -Force | Out-Null
  }

  if (Test-Path $env:TEMP\Kali) {
    Remove-Item -Path $env:TEMP\Kali -Recurse -Force | Out-Null
  }

  Invoke-WebRequest -Uri https://aka.ms/wsl-kali-linux-new `
    -OutFile $env:TEMP\Kali.zip -UseBasicParsing

  New-Item -Type Directory -Path $env:TEMP\Kali | Out-Null

  Expand-Archive $env:TEMP\Kali.zip $env:TEMP\Kali\

  if (Test-Path "${env:TEMP}\Kali\kali.exe") {
    Move-Item $env:TEMP\Kali\* $env:SYSTEMDRIVE\Kali
  } else {
    $package = (Get-ChildItem -Path $env:TEMP\Kali\ `
        | Where-Object { $_.Name -match "^DistroLauncher-Appx_.+_x64\.appx$" } `
        | Sort-Object Name -Descending `
        | Select-Object -First 1).FullName

    Rename-Item $package $env:TEMP\Kali\Kali.zip

    Expand-Archive $env:TEMP\Kali\Kali.zip $env:SYSTEMDRIVE\Kali
  }

  Set-Content $env:SYSTEMDRIVE\Kali\desktop.ini @"
[.ShellClassInfo]
IconResource=$env:SYSTEMDRIVE\Kali\kali.exe,0
"@

  attrib +S +H $env:SYSTEMDRIVE\Kali\desktop.ini
  attrib +S $env:SYSTEMDRIVE\Kali

  Remove-Item -Path $env:TEMP\Kali.zip -Force | Out-Null
  Remove-Item -Path $env:TEMP\Kali -Recurse -Force | Out-Null
} else {
  Write-Output "A version of Kali is already installed. Not overwriting the installed version..."
}
