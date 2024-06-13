$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName    = $env:chocolateyPackageName
  unzipLocation  = $env:TEMP
  fileType       = "exe"
  silentArgs     = "/allUsers /S"
  url64bit       = "https://www.xmind.app/zen/download/win64"
  checksum64     = "8d5efad51a0f466c63ba6901062cbe7958726b33c9c99a41e76f0c0d185b1162"
  checksumType64 = "sha256"
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
