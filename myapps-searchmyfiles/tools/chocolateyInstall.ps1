# One-time package rename
if (Test-Path "../../searchmyfiles-julian") {
    Remove-Item -Path "../../searchmyfiles-julian" -Recurse -Force
    return
}

$url = 'http://www.nirsoft.net/utils/searchmyfiles.zip'
$cksum = '2450b31656beb3599e96f652e9e9b787dc3eff1fa91342840368d0e468b87be0'

if ([Environment]::Is64BitOperatingSystem) {
    $url = 'http://www.nirsoft.net/utils/searchmyfiles-x64.zip'
    $cksum = 'ebe9220d7fe319d61552ab30eae9dee0d18e264b4a5ae172884c34a66c69ad57'
}

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Set-Content -Path "searchmyfiles.exe.gui" -Value $null

Install-ChocolateyZipPackage -PackageName "searchmyfiles" `
                             -UnzipLocation $toolsDir `
                             -Url $url `
                             -Checksum $cksum `
                             -ChecksumType "sha256"
