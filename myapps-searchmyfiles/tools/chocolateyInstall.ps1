# One-time package rename
if (Test-Path "../../searchmyfiles-julian") {
    Remove-Item -Path "../../searchmyfiles-julian" -Recurse -Force
    return
}

$url = 'http://www.nirsoft.net/utils/searchmyfiles.zip'
$cksum = 'dc147e7a1fbf8d0025bf57f587c95a7303ab63d593c44b613ca2fbc91dfe4e9d'

if ([Environment]::Is64BitOperatingSystem) {
    $url = 'http://www.nirsoft.net/utils/searchmyfiles-x64.zip'
    $cksum = '9665673037a2f95f44a6c56651883a8105cda27aa79aa4620c508c48a9547fea'
}

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Set-Content -Path "searchmyfiles.exe.gui" -Value $null

Install-ChocolateyZipPackage -PackageName "searchmyfiles" `
                             -UnzipLocation $toolsDir `
                             -Url $url `
                             -Checksum $cksum `
                             -ChecksumType "sha256"
