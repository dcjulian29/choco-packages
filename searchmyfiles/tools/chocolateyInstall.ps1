$url = 'http://www.nirsoft.net/utils/searchmyfiles.zip'
$cksum = '3ba8f93dc0430e8eb4c6a75eeb66ce167b588dcd4dfddcd81bf3c547abaf5344'

if ([Environment]::Is64BitOperatingSystem) {
    $url = 'http://www.nirsoft.net/utils/searchmyfiles-x64.zip'
    $cksum = '6e00a6b765da99a5b48e79b5d4677bbdd863c723897a96cb005ff13a53b7ce86'
}

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Set-Content -Path "searchmyfiles.exe.gui" -Value $null

Install-ChocolateyZipPackage -PackageName "searchmyfiles" `
                             -UnzipLocation $toolsDir `
                             -Url $url `
                             -Checksum $cksum `
                             -ChecksumType "sha256"
