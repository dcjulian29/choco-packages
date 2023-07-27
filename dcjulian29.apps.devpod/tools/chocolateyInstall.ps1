$ErrorActionPreference = 'Stop';

$version = $env:chocolateyPackageVersion

$packageArgs = @{
  packageName    = $env:chocolateyPackageName
  unzipLocation  = $env:TEMP
  fileType       = "msi"
  silentArgs     = "/PASSIVE /NORESTART"
  url64bit       = "https://github.com/loft-sh/devpod/releases/download/v$version/DevPod_windows_x64_en-US.msi"
  checksum64     = "0459f4d8c5f079f78c4b60bc16379d3bd6826029b56139d6714a5aa2bbdb5e8d"
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
