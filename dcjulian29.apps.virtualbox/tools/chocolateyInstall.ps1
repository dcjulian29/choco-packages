$version = "7.0.14"
$build = 161095
$cksum = "9769bae970244249e043bde9c74d704d25a80773acced5c59a04df64a10a5db7"
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

Write-Output "Attempting to download installer package..."
Remove-Item -Path "./virtualbox.exe" -Force -ErrorAction SilentlyContinue
Invoke-WebRequest -Uri $url -OutFile "virtualbox.exe"

# For some stupid reason, Oracle sometimes causes the first attempt to fail randomly...
if (Test-Path -Path "./virtualbox.exe") {
  # Download package have been over 75MB for a long time so if not, re-download.
  if ((Get-Item ".\virtualbox.exe").Length -lt 78643200) {
    Write-Output "Validation failed... Attempting to download installer package again..."

    Remove-Item -Path "./virtualbox.exe" -Force
    Invoke-WebRequest -Uri $url -OutFile "virtualbox.exe"
  }
}

if (-not (Test-Path -Path "./virtualbox.exe")) {
  if ((Get-Item ".\virtualbox.exe").Length -lt 78643200) {
    throw "Validation failed again...Couldn't download installer package!"
  }
}

$hash = (Get-FileHash -Path "./virtualbox.exe" -Algorithm SHA256).Hash.ToLowerInvariant()

if ($cksum -ne $hash) {
  throw "Downloaded package does not match checksum ($cksum != $hash)"
}

Invoke-Expression "./virtualbox.exe -extract -silent"

if (-not (Test-Path -Path "${env:TEMP}\VirtualBox-$version-r$build.msi")) {
  throw "Error extracting virtualbox installer from package!"
}

Start-Process -FilePath "msiexec.exe" -ArgumentList $props -NoNewWindow -Wait

Get-Content $log

Pop-Location
