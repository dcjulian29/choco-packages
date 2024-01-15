$ErrorActionPreference = 'Stop';

$version = $env:chocolateyPackageVersion
$url = "https://github.com/rhysd/dotfiles/releases/download/v$version/dotfiles_windows_amd64.exe.zip"

Install-ChocolateyZipPackage @{
  packageName    = $env:chocolateyPackageName
  unzipLocation  = $PSScriptRoot
  fileType       = 'exe'
  url64bit       = $url
  checksum64     = '5ff598bcb2eafbb2146b8d420d8e4fb08be892fb09fdab2007614390025a8f00'
  checksumType64 = 'sha256'
}
