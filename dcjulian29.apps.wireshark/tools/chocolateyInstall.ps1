$installArgs = @{
  PackageName    = $env:chocolateyPackageName
  FileType       = "EXE"
  SilentArgs     = "/S /EXTRACOMPONENTS=sshdump,udpdump,etwdump,wifidump /DESKTOPICON=no /QUICKLAUNCHICON=no"
  url            = "https://2.na.dl.wireshark.org/win64/Wireshark-4.2.5-x64.exe"
  checksum       = "3d921ee584d0984f694f60a771a6581a6f32a9de995a5cd4bca1931185a4e618"
  checksumType   = "sha256"
  ValidExitCodes = @(0, 3010)
}

Install-ChocolateyPackage @installArgs
