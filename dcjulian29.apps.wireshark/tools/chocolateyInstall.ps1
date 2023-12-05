$installArgs = @{
  PackageName    = $env:chocolateyPackageName
  FileType       = "EXE"
  SilentArgs     = "/S /EXTRACOMPONENTS=sshdump,udpdump,etwdump,wifidump /DESKTOPICON=no /QUICKLAUNCHICON=no"
  url            = "https://2.na.dl.wireshark.org/win64/Wireshark-4.2.0-x64.exe"
  checksum       = "a68a8298662af5cc4bb4a454c66f49d0bcc0bacfd16e00e818b4c77ae8281c26"
  checksumType   = "sha256"
  ValidExitCodes = @(0, 3010)
}

Install-ChocolateyPackage @installArgs
