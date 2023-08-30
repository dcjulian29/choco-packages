$ErrorActionPreference = 'Stop';

$version = $env:chocolateyPackageVersion

$packageArgs = @{
  packageName    = $env:chocolateyPackageName
  unzipLocation  = $env:TEMP
  fileType       = "msi"
  silentArgs     = "/PASSIVE /NORESTART"
  url64bit       = "https://github.com/loft-sh/devpod/releases/download/v$version/DevPod_windows_x64_en-US.msi"
  checksum64     = "d02f787863eb23369ef669d5759fcb4251df1e7a56008e400c3c77eca407a0a3"
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
