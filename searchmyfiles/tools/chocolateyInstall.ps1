$url = 'http://www.nirsoft.net/utils/searchmyfiles.zip'
$cksum = '8aea45db108be6201c7999a550ec882c6f6837c197fef40172bc7261610383c6'

if ([Environment]::Is64BitOperatingSystem) {
    $url = 'http://www.nirsoft.net/utils/searchmyfiles-x64.zip'
    $cksum = '80bd0878000409248172a94c653c538cebc627db50ad369434c11240b7700ee6'
}

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Set-Content -Path "searchmyfiles.exe.gui" -Value $null

Install-ChocolateyZipPackage -PackageName "searchmyfiles" `
                             -UnzipLocation $toolsDir `
                             -Url $url `
                             -Checksum $cksum `
                             -ChecksumType "sha256"
