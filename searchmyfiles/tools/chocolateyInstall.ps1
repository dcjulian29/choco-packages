$url = 'http://www.nirsoft.net/utils/searchmyfiles.zip'
$cksum = '7d9bd7597b5d85ec21424768bf659b62c8c1057f518d40cf013fed9f645971e4'

if ([Environment]::Is64BitOperatingSystem) {
    $url = 'http://www.nirsoft.net/utils/searchmyfiles-x64.zip'
    $cksum = 'e3483c6abf4ad16e0391f5ee6a11df82b76f57c2f45b1861c17c4361f382139a'
}

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Set-Content -Path "searchmyfiles.exe.gui" -Value $null

Install-ChocolateyZipPackage -PackageName "searchmyfiles" `
                             -UnzipLocation $toolsDir `
                             -Url $url `
                             -Checksum $cksum `
                             -ChecksumType "sha256"
