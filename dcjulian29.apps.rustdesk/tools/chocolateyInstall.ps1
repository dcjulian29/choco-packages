$installArgs = @{
  PackageName    = $env:chocolateyPackageName
  FileType       = "EXE"
  SilentArgs     = "--silent-install"
  url            = "https://github.com/rustdesk/rustdesk/releases/download/1.2.2/rustdesk-1.2.2-x86_64.exe"
  checksum       = "7d8790e65a906706a93734b91efa6dfdb732f9897e04707233fe48033bd5654e"
  checksumType   = "sha256"
  ValidExitCodes = @(0)
}

Install-ChocolateyPackage @installArgs
