$url = 'http://www.nirsoft.net/utils/searchmyfiles.zip'
$cksum = 'A3351869963A5C1F92D14F8E6964CA9B18E00FA15EA9C74F11C08A209279F78F'

if ([Environment]::Is64BitOperatingSystem) {
    $url = 'http://www.nirsoft.net/utils/searchmyfiles-x64.zip'
    $cksum = '4A78AAD1D776BAE5D791667F7083351E386A09A981B0DC4697AF65170212756A'
}

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Set-Content -Path "searchmyfiles.exe.gui" -Value $null

Install-ChocolateyZipPackage -PackageName "searchmyfiles" `
                             -UnzipLocation $toolsDir `
                             -Url $url `
                             -Checksum $cksum `
                             -ChecksumType "sha256"
