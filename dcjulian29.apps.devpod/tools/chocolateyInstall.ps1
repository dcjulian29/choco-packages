$ErrorActionPreference = 'Stop';

$version = $env:chocolateyPackageVersion

$packageArgs = @{
  packageName    = $env:chocolateyPackageName
  unzipLocation  = $env:TEMP
  fileType       = "msi"
  silentArgs     = "/PASSIVE /NORESTART"
  url64bit       = "https://github.com/loft-sh/devpod/releases/download/v$version/DevPod_windows_x64_en-US.msi"
  checksum64     = "59610E40D43CBE12B59D5E9DA0A8A19B1AC0480775897F6340BC2DF6E107C095"
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
