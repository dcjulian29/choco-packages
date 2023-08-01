$installArgs = @{
  PackageName    = $env:chocolateyPackageName
  FileType       = "EXE"
  SilentArgs     = "/S /EXTRACOMPONENTS=sshdump,udpdump,etwdump,wifidump /DESKTOPICON=no /QUICKLAUNCHICON=no"
  url            = "https://2.na.dl.wireshark.org/win64/Wireshark-win64-4.0.7.exe"
  checksum       = "7e05d013f33b21366b6d3663acdb2143549e83704ca646737fe65298f244a381"
  checksumType   = "sha256"
  ValidExitCodes = @(0, 3010)
}

Install-ChocolateyPackage @installArgs
