$ErrorActionPreference = 'Stop';

$version = $env:chocolateyPackageVersion

$packageArgs = @{
  packageName    = $env:chocolateyPackageName
  unzipLocation  = $env:TEMP
  fileType       = "msi"
  silentArgs     = "/PASSIVE /NORESTART"
  url64bit       = "https://github.com/loft-sh/devpod/releases/download/v$version/DevPod_windows_x64_en-US.msi"
  checksum64     = "dc94d4d810901ae94ac290b273966c6f79093a4204f90ca0d9819664ac7c8edc"
  checksumType64 = "sha256"
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs

# CLI

$requestArgs = @{
  Uri = "https://github.com/loft-sh/devpod/releases/download/v$version/devpod-windows-amd64.exe"
  OutFile = "$PSScriptRoot\devpod.exe"
}

Invoke-WebRequest @requestArgs
