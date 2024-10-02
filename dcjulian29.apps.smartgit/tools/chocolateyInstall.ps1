$ErrorActionPreference = 'Stop';

$version = $env:chocolateyPackageVersion -replace '\.', '_'
$packageName = $env:chocolateyPackageName
$url = "https://julianscorner.com/dl/smartgit-win-$version.zip"

$packageArgs = @{
  packageName    = $packageName
  unzipLocation  = $PSScriptRoot
  fileType       = "exe"
  url64bit       = $url
  checksum64     = "629ffad833ee8a41d26bcf115cfdd27bb51db5815dfbc36792464474c75a638b"
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
