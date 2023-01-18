$version = "7.0.4"
$build = 154605

$log = "virtualbox-$(([Guid]::NewGuid()).Guid).log"
$url = "https://download.virtualbox.org/virtualbox/$version/VirtualBox-$version-$build-Win.exe"
$props = @(
    "/i"
    "${env:TEMP}\VirtualBox-$version-r$build.msi"
    "/passive"
    "/norestart"
    "/l* $log"
    "VBOX_INSTALLDESKTOPSHORTCUT=0"
    "VBOX_INSTALLQUICKLAUNCHSHORTCUT=0"
    "VBOX_REGISTERFILEEXTENSIONS=1"
    "VBOX_START=0"
)

Push-Location $env:TEMP

Invoke-WebRequest -Uri $url -OutFile "virtualbox.exe"

# For some stupid reason, Oracle causes the first attempt to fail randomly...
if (Test-Path -Path "./virtualbox.exe") {
  # Download package have been over 75MB for a long time so if not, re-download.
  if ((Get-Item ".\virtualbox.exe").Length - lt 78643200)) {
    Remove-Item -Path "./virtualbox.exe" -Force
    Invoke-WebRequest -Uri $url -OutFile "virtualbox.exe"
  }
}

if (-not (Test-Path -Path "./virtualbox.exe")) {
  throw "Error downloading virtualbox!"
}

if ((Get-Item ".\virtualbox.exe").Length - lt 78643200)) {
  throw "Downloaded package is not big enough!"
}

Invoke-Expression "./virtualbox.exe -extract -silent"

if (-not (Test-Path -Path "${env:TEMP}\VirtualBox-$version-r$build.msi")) {
  throw "Error extracting virtualbox installer from package!"
}

Invoke-Expression "msiexec.exe $($props -join ' ')"

Get-Content $log

Pop-Location
