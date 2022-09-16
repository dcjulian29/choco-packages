# One-time package rename
if (Test-Path "../../searchmyfiles-julian") {
    Remove-Item -Path "../../searchmyfiles-julian" -Recurse -Force
    return
}

$url = 'http://www.nirsoft.net/utils/searchmyfiles.zip'
$cksum = '77aa5b1d89b0fc7173a71d09acf3aaf9892c972da0a34fd17aed8ae6b979c3a1'

if ([Environment]::Is64BitOperatingSystem) {
    $url = 'http://www.nirsoft.net/utils/searchmyfiles-x64.zip'
    $cksum = 'c2dfccf2f68ab90d7aef81d8272ab79231abab8300e8f1159d4011f840d76c8e'
}

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Set-Content -Path "searchmyfiles.exe.gui" -Value $null

Install-ChocolateyZipPackage -PackageName "searchmyfiles" `
                             -UnzipLocation $toolsDir `
                             -Url $url `
                             -Checksum $cksum `
                             -ChecksumType "sha256"
