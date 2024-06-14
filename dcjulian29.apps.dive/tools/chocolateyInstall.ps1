$ErrorActionPreference = 'Stop'

$version = $env:chocolateyPackageVersion
$packageName = $env:chocolateyPackageName
$url = "https://github.com/wagoodman/dive/releases/download/v$version/dive_$($version)_windows_amd64.zip"
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $packageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url64bit       = $url
  checksum64     = 'b60d750852543e5a4b38c42590e2036aa2a8026cdb14d835090399f5e1312192'
  checksumType64 = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
