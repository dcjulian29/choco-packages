$installArgs = @{
    PackageName    = $env:chocolateyPackageName
    FileType       = "EXE"
    SilentArgs     = "/S /EXTRACOMPONENTS=sshdump,udpdump,etwdump,wifidump /DESKTOPICON=no /QUICKLAUNCHICON=no"
    Url            = "https://www.nirsoft.net/utils/searchmyfiles.zip"
    Url64          = "https://www.nirsoft.net/utils/searchmyfiles-x64.zip"
    checksum       = "b80c3e11a3a800ba9d3af922c7e34e0494197a580a7192308dea3e74646c8096"
    checksumType   = "sha256"
    checksum64     = "51545892d6cc83391a3cd0d8bcc77911fee41c4a24fea2b219a6801a62317b16"
    checksum64Type = "sha256"
    UnzipLocation  = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
    ValidExitCodes = @(0, 3010)
}

Install-ChocolateyZipPackage @installArgs
