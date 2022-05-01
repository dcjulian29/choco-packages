# One-time package rename
if (Test-Path "../../searchmyfiles-julian") {
    Remove-Item -Path "../../searchmyfiles-julian" -Recurse -Force
    return
}

$url = 'http://www.nirsoft.net/utils/searchmyfiles.zip'
$cksum = '6dcb957e93ceaaa388da3da62d70cde9268746340e9d9943b63df245a1dc1d4f'

if ([Environment]::Is64BitOperatingSystem) {
    $url = 'http://www.nirsoft.net/utils/searchmyfiles-x64.zip'
    $cksum = 'acebecb9079c79517b2c45678e7b14f212c40d37592a58bfd793ce26728100ec'
}

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Set-Content -Path "searchmyfiles.exe.gui" -Value $null

Install-ChocolateyZipPackage -PackageName "searchmyfiles" `
                             -UnzipLocation $toolsDir `
                             -Url $url `
                             -Checksum $cksum `
                             -ChecksumType "sha256"
