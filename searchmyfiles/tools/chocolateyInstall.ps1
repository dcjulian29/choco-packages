$url = 'http://www.nirsoft.net/utils/searchmyfiles.zip'
$cksum = '32078F2AA5E5F1F5D7784021F82B470A6EB1EF1BC0C27CF36E7BD70E100856AB'

if ([Environment]::Is64BitOperatingSystem) {
    $url = 'http://www.nirsoft.net/utils/searchmyfiles-x64.zip'
    $cksum = 'A5F8A906E72EA3675EC4B5128E589B5A1DE0D50123933496B3B212E1E858E24F'
}

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Set-Content -Path "searchmyfiles.exe.gui" -Value $null

Install-ChocolateyZipPackage -PackageName "searchmyfiles" `
                             -UnzipLocation $toolsDir `
                             -Url $url `
                             -Checksum $cksum `
                             -ChecksumType "sha256"
