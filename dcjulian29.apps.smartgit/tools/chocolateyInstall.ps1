$ErrorActionPreference = 'Stop';

$version = $env:chocolateyPackageVersion -replace '\.', '_'
$packageName = $env:chocolateyPackageName
$url = "https://julianscorner.com/dl/smartgit-win-$version.zip"

$packageArgs = @{
  packageName    = $packageName
  unzipLocation  = $PSScriptRoot
  fileType       = "exe"
  url64bit       = $url
  checksum64     = "324572f2ea37085f69b382e43e8a81ed2287cf907e4feb464978df418760a6cd"
  checksumType64 = "sha256"
}

Install-ChocolateyZipPackage @packageArgs

$installArgs = @{
  packageName    = $packageName
  file           = $(Join-Path -Path $PSScriptRoot -ChildPath "smartgit-$version-setup.exe")

  silentArgs     = "/SILENT /SUPPRESSMSGBOXES /NORESTART /SP-"
  validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @installArgs
