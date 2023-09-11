$installArgs = @{
  PackageName    = $env:chocolateyPackageName
  FileType       = "EXE"
  SilentArgs     = "/S /EXTRACOMPONENTS=sshdump,udpdump,etwdump,wifidump /DESKTOPICON=no /QUICKLAUNCHICON=no"
  url            = "https://2.na.dl.wireshark.org/win64/Wireshark-win64-4.0.8.exe"
  checksum       = "8243e019d2bd73c81de53c67ddb23d877ecec2fc1699c9aa074ccaa2d7d9b267"
  checksumType   = "sha256"
  ValidExitCodes = @(0, 3010)
}

Install-ChocolateyPackage @installArgs
