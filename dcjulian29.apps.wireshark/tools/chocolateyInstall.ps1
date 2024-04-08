$installArgs = @{
  PackageName    = $env:chocolateyPackageName
  FileType       = "EXE"
  SilentArgs     = "/S /EXTRACOMPONENTS=sshdump,udpdump,etwdump,wifidump /DESKTOPICON=no /QUICKLAUNCHICON=no"
  url            = "https://2.na.dl.wireshark.org/win64/Wireshark-4.2.4-x64.exe"
  checksum       = "b621718ffe64748590ea9568fbbed0f3d86b0939906dc9f7fe064e20ce385492"
  checksumType   = "sha256"
  ValidExitCodes = @(0, 3010)
}

Install-ChocolateyPackage @installArgs
