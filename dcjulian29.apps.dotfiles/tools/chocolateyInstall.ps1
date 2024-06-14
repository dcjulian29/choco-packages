$ErrorActionPreference = 'Stop'

$version = $env:chocolateyPackageVersion
$packageName = $env:chocolateyPackageName
$url = "https://github.com/rhysd/dotfiles/releases/download/v$version/dotfiles_windows_amd64.exe.zip"
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $packageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url64bit       = $url
  checksum64     = 'ca65b50816554551851bbae28cfad9bf1715ed80fb5fd5142b21a20ffafb0cf3'
  checksumType64 = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
