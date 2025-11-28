$ErrorActionPreference = 'Stop';

$version = $env:chocolateyPackageVersion -replace '\.', '_'
$packageName = $env:chocolateyPackageName
$package_zip = "smartgit-win-$version.zip"
$package_setup = "smartgit-0$version-setup.exe"
$url = "https://julianscorner.com/dl/$package_zip"

$packageArgs = @{
  packageName    = $packageName
  unzipLocation  = $PSScriptRoot
  fileType       = "exe"
  url64bit       = $url
  checksum64     = "bb45105b2364a361bf6a2b8bcd36f15394c3368d00ece15342dc9d183c9e7a0b"
  checksumType64 = "sha256"
}

Install-ChocolateyZipPackage @packageArgs

$installArgs = @{
  packageName    = $packageName
  file           = $(Join-Path -Path $PSScriptRoot -ChildPath $package_setup)

  silentArgs     = "/SILENT /SUPPRESSMSGBOXES /NORESTART /SP-"
  validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @installArgs
