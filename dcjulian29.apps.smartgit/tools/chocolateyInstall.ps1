$ErrorActionPreference = 'Stop';

$version = $env:chocolateyPackageVersion -replace '\.', '_'
$packageName = $env:chocolateyPackageName
$url = "https://julianscorner.com/dl/smartgit-win-$version.zip"

$packageArgs = @{
  packageName    = $packageName
  unzipLocation  = $PSScriptRoot
  fileType       = "exe"
  url64bit       = $url
  checksum64     = "632b47d5cd692a6072d09d29155ea62d189cd574fed1c3d12c78b6cf3c0434cd"
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
