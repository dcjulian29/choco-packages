$installArgs = @{
    PackageName    = $env:chocolateyPackageName
    FileType       = "EXE"
    SilentArgs     = "/S /EXTRACOMPONENTS=sshdump,udpdump,etwdump,wifidump /DESKTOPICON=no /QUICKLAUNCHICON=no"
    Url            = "https://www.nirsoft.net/utils/searchmyfiles.zip"
    Url64          = "https://www.nirsoft.net/utils/searchmyfiles-x64.zip"
    checksum       = "d5b1ff964d478171a353cd787141ad7b6f679bc0070a142237c0bfc2d6793d6f"
    checksumType   = "sha256"
    checksum64     = "9587a84dadcf6035b2ad20a31ab434bf4d2fd96a1d5939186de90f45bc4ecf93"
    checksum64Type = "sha256"
    UnzipLocation  = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    ValidExitCodes = @(0, 3010)
}

Install-ChocolateyZipPackage @installArgs
