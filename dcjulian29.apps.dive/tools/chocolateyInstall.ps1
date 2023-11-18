$ErrorActionPreference = 'Stop';

$version = $env:chocolateyPackageVersion
$url = "https://github.com/wagoodman/dive/releases/download/v$version/dive_$($version)_windows_amd64.zip"

Install-ChocolateyZipPackage @{
  packageName    = $env:chocolateyPackageName
  unzipLocation  = $PSScriptRoot
  fileType       = 'exe'
  url64bit       = $url
  checksum64     = '6f8680c8d906cbd7ef4df3ec7cea90eece95bec45083b8ba6ea1d8a50d645667'
  checksumType64 = 'sha256'
}
