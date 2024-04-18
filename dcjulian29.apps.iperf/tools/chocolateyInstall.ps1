$installArgs = @{
    PackageName    = $env:chocolateyPackageName
    Url            = "https://iperf.fr/download/windows/iperf-${env:ChocolateyPackageVersion}-win32.zip"
    Url64          = "https://iperf.fr/download/windows/iperf-${env:ChocolateyPackageVersion}-win64.zip"
    checksum       = "b3f8e262c17a000a30bf4f2135dfed644587cf2ec649f878aea8e9de51ffc8f2"
    checksumType   = "sha256"
    checksum64     = "3c3db693c1bdcc902ca9198fc716339373658233b3392ffe3d467f7695762cd1"
    checksum64Type = "sha256"
    UnzipLocation  = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
}

Install-ChocolateyZipPackage @installArgs
