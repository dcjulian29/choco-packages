# One-time package rename
if (Test-Path "../../searchmyfiles-julian") {
    Remove-Item -Path "../../searchmyfiles-julian" -Recurse -Force
    return
}

$url = 'http://www.nirsoft.net/utils/searchmyfiles.zip'
$cksum = 'b60b59c1a8088bae4315e229b4cea7fe9606c175f31408a4803e80fe7179162b'

if ([Environment]::Is64BitOperatingSystem) {
    $url = 'http://www.nirsoft.net/utils/searchmyfiles-x64.zip'
    $cksum = 'cd75a560ba59f0b3030c022e8919657e6eedd3f48c95dd0fc2acdfa51c33a326'
}

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Set-Content -Path "searchmyfiles.exe.gui" -Value $null

Install-ChocolateyZipPackage -PackageName "searchmyfiles" `
                             -UnzipLocation $toolsDir `
                             -Url $url `
                             -Checksum $cksum `
                             -ChecksumType "sha256"
