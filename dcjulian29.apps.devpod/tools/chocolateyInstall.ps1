$ErrorActionPreference = 'Stop';

$version = $env:chocolateyPackageVersion

$packageArgs = @{
  packageName    = $env:chocolateyPackageName
  unzipLocation  = $PSScriptRoot
  fileType       = "msi"
  url64bit       = "https://github.com/loft-sh/devpod/releases/download/v$version/DevPod_windows_x64_en-US.msi"
  checksum64     = "748e293d243566a02fc43f75dcea88739709cd67fcc3b7adcd97b18e2a7d1455"
  checksumType64 = "sha256"
}

Install-ChocolateyPackage @packageArgs


$installArgs = @{
  packageName    = $env:chocolateyPackageName
  file           = $(Join-Path -Path $PSScriptRoot -ChildPath "DevPod_windows_x64_en-US.msi")
  silentArgs     = "/PASSIVE /NORESTART"
  validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @installArgs


# CLI

Invoke-WebRequest -Uri "https://github.com/loft-sh/devpod/releases/v$version/devpod-windows-amd64.exe" -OutFile $PSScriptRoot\devpod.exe
