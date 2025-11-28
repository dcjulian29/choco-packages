$ErrorActionPreference = 'Stop';

$version = $env:chocolateyPackageVersion -replace '\.', '_'
$packageName = $env:chocolateyPackageName
$url = "https://julianscorner.com/dl/smartgit-$version.zip"

$packageArgs = @{
  packageName    = $packageName
  unzipLocation  = $PSScriptRoot
  fileType       = "exe"
  url64bit       = $url
  checksum64     = "7d1dc0fa5e1d0da58f1ae419d6f62a56f84d8dec35bc704f6c55c051da09d9b2"
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
