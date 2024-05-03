$version = $env:chocolateyPackageVersion
$build = 162988
$cksum = "4c83894c00aa9f55f7e0f70807210896ba32e1222d4ff1d0b9487af81f328f36"
$install = "VirtualBox-$version-$build-Win.exe"
$log = "virtualbox-$version-$build.log"
$url = "https://download.virtualbox.org/virtualbox/$version/$install"
$props = @(
  "/i"
  "VirtualBox-$version-r$build.msi"
  "/passive"
  "/norestart"
  "/l* $log"
  "VBOX_INSTALLDESKTOPSHORTCUT=0"
  "VBOX_INSTALLQUICKLAUNCHSHORTCUT=0"
  "VBOX_REGISTERFILEEXTENSIONS=1"
  "VBOX_START=0"
)

$extract = @(
  "--extract"
  "--silent"
)

Push-Location $env:TEMP

Write-Output "Attempting to download installer package..."
Remove-Item -Path $install -Force -ErrorAction SilentlyContinue
Invoke-WebRequest -Uri $url -OutFile $install

# For some reason, Oracle sometimes causes the first attempt to fail...
if (Test-Path -Path $install) {
  # Download package have been over 75MB for a long time so if not, re-download.
  if ((Get-Item $install).Length -lt 78643200) {
    Write-Output "Validation failed... Attempting to download installer package again..."

    Remove-Item -Path $install -Force
    Invoke-WebRequest -Uri $url -OutFile $install
  }
}

if (-not (Test-Path -Path $install)) {
  if ((Get-Item ".\$install").Length -lt 78643200) {
    throw "Validation failed again...Couldn't download installer package!"
  }
}

$hash = (Get-FileHash -Path $install -Algorithm SHA256).Hash.ToLowerInvariant()

if ($cksum -ne $hash) {
  throw "Downloaded package does not match checksum ($cksum != $hash)"
}

Start-Process -FilePath $env:TEMP\$install -ArgumentList $extract -NoNewWindow -Wait

if (-not (Test-Path -Path "VirtualBox-$version-r$build.msi")) {
  throw "Error extracting virtualbox installer from package!"
}

Start-Process -FilePath "msiexec.exe" -ArgumentList $props -NoNewWindow -Wait

if (-not (Test-Path -Path $log)) {
  throw "Error installing virtualbox from MSI!"
}

Get-Content $log

Pop-Location
