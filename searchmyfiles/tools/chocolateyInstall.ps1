$url = 'http://www.nirsoft.net/utils/searchmyfiles.zip'
$cksum = '1e212febca9b38f7152313c0497fdf485848cf79ee76043100e1a621a1075211'

if ([Environment]::Is64BitOperatingSystem) {
    $url = 'http://www.nirsoft.net/utils/searchmyfiles-x64.zip'
    $cksum = 'fc6db22e92950aa6faa1fa8ffb6341fcd2ed24a7c22fa11bf6f2282bba92e272'
}

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Set-Content -Path "searchmyfiles.exe.gui" -Value $null

Install-ChocolateyZipPackage -PackageName "searchmyfiles" `
                             -UnzipLocation $toolsDir `
                             -Url $url `
                             -Checksum $cksum `
                             -ChecksumType "sha256"
