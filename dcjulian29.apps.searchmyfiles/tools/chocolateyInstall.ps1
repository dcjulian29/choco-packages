$installArgs = @{
    PackageName    = $env:chocolateyPackageName
    FileType       = "EXE"
    SilentArgs     = "/S /EXTRACOMPONENTS=sshdump,udpdump,etwdump,wifidump /DESKTOPICON=no /QUICKLAUNCHICON=no"
    Url            = "https://www.nirsoft.net/utils/searchmyfiles.zip"
    Url64          = "https://www.nirsoft.net/utils/searchmyfiles-x64.zip"
    checksum       = "2450b31656beb3599e96f652e9e9b787dc3eff1fa91342840368d0e468b87be0"
    checksumType   = "sha256"
    checksum64     = "ebe9220d7fe319d61552ab30eae9dee0d18e264b4a5ae172884c34a66c69ad57"
    checksum64Type = "sha256"
    UnzipLocation  = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    ValidExitCodes = @(0, 3010)
}

Install-ChocolateyZipPackage @installArgs
