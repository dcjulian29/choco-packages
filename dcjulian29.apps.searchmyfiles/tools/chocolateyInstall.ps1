$installArgs = @{
    PackageName    = $env:chocolateyPackageName
    FileType       = "EXE"
    SilentArgs     = "/S /EXTRACOMPONENTS=sshdump,udpdump,etwdump,wifidump /DESKTOPICON=no /QUICKLAUNCHICON=no"
    Url            = "https://www.nirsoft.net/utils/searchmyfiles.zip"
    Url64          = "https://www.nirsoft.net/utils/searchmyfiles-x64.zip"
    checksum       = "d5b1ff964d478171a353cd787141ad7b6f679bc0070a142237c0bfc2d6793d6f"
    checksumType   = "sha256"
    checksum64     = "b80c3e11a3a800ba9d3af922c7e34e0494197a580a7192308dea3e74646c8096"
    checksum64Type = "sha256"
    UnzipLocation  = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    ValidExitCodes = @(0, 3010)
}

Install-ChocolateyZipPackage @installArgs
