$ErrorActionPreference = 'Stop';

$version = $env:chocolateyPackageVersion -replace '.', '_'
$packageName = $env:chocolateyPackageName

$packageArgs = @{
  packageName    = $packageName
  unzipLocation  = $PSScriptRoot
  fileType       = "exe"
  url64bit       = "https://www.syntevo.com/downloads/smartgit/smartgit-win-$version.zip"
  checksum64     = "748e293d243566a02fc43f75dcea88739709cd67fcc3b7adcd97b18e2a7d1455"
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