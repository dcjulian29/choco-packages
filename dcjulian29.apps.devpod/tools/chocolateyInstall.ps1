$ErrorActionPreference = 'Stop';

$version = $env:chocolateyPackageVersion

$packageArgs = @{
  packageName    = $env:chocolateyPackageName
  unzipLocation  = $PSScriptRoot
  fileType       = "msi"
  url64bit       = "https://github.com/loft-sh/devpod/releases/download/v$version/DevPod_windows_x64_en-US.msi"
  checksum64     = "DC814AB050F2270AC10D614715EC4F1E7BFB7A703583A82C412D2EAF089872C4"
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
