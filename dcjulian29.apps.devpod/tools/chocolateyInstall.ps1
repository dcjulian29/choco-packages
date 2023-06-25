$ErrorActionPreference = 'Stop';

$version = $env:chocolateyPackageVersion

$packageArgs = @{
  packageName    = $env:chocolateyPackageName
  unzipLocation  = $env:TEMP
  fileType       = "msi"
  silentArgs     = "/PASSIVE /NORESTART"
  url64bit       = "https://github.com/loft-sh/devpod/releases/download/v$version/DevPod_windows_x64_en-US.msi"
  checksum64     = "a0add47e59a653e4465ac885a323ef0accd013d9b69736234d44cb91a2761a82"
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
