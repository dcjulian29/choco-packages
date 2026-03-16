$installArgs = @{
    PackageName    = $env:chocolateyPackageName
    FileType       = "EXE"
    SilentArgs     = "/S /EXTRACOMPONENTS=sshdump,udpdump,etwdump,wifidump /DESKTOPICON=no /QUICKLAUNCHICON=no"
    Url            = "https://www.nirsoft.net/utils/searchmyfiles.zip"
    Url64          = "https://www.nirsoft.net/utils/searchmyfiles-x64.zip"
    checksum       = "aa05b725e6c3c32f6c9d35bd55025ce07ae30a2e4bc12d2115f45b2bc8f54a36"
    checksumType   = "sha256"
    checksum64     = "f29ea7c66c8ed2af1069ec6209b587fde6205244df9c91cde8aa8e30db97f81a"
    checksum64Type = "sha256"
    UnzipLocation  = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    ValidExitCodes = @(0, 3010)
}

Install-ChocolateyZipPackage @installArgs
