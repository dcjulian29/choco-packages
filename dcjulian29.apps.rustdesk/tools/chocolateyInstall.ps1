$version = $env:chocolateyPackageVersion
$sha256 = "23b661d7bc171cd500d5096456905283ffe06479582b62d3bd5066633935d43e"

$installArgs = @{
  PackageName    = $env:chocolateyPackageName
  FileType       = "EXE"
  SilentArgs     = "--silent-install"
  url            = "https://github.com/rustdesk/rustdesk/releases/download/$version/rustdesk-$version-x86_64.exe"
  checksum       = $sha256
  checksumType   = "sha256"
  ValidExitCodes = @(0)
}

Install-ChocolateyPackage @installArgs
