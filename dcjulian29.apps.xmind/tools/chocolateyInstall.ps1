$ErrorActionPreference = 'Stop';

$packageArgs = @{
  packageName    = $env:chocolateyPackageName
  unzipLocation  = $env:TEMP
  fileType       = "exe"
  silentArgs     = "/allUsers /S"
  url64bit       = "https://www.xmind.app/zen/download/win64"
  checksum64     = "586a8a952e2649f62cbb493d5c32d2e50f3625d8996e493ecd6c4afbb3b22b05"
  checksumType64 = "sha256"
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
