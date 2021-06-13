$url = 'http://www.nirsoft.net/utils/searchmyfiles.zip'
$cksum = '32078f2aa5e5f1f5d7784021f82b470a6eb1ef1bc0c27cf36e7bd70e100856ab'

if ([Environment]::Is64BitOperatingSystem) {
    $url = 'http://www.nirsoft.net/utils/searchmyfiles-x64.zip'
    $cksum = 'a5f8a906e72ea3675ec4b5128e589b5a1de0d50123933496b3b212e1e858e24f'
}

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Set-Content -Path "searchmyfiles.exe.gui" -Value $null

Install-ChocolateyZipPackage -PackageName "searchmyfiles" `
                             -UnzipLocation $toolsDir `
                             -Url $url `
                             -Checksum $cksum `
                             -ChecksumType "sha256"
