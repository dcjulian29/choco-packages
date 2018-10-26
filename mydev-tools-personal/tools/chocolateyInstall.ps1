$downloadPath = "$env:TEMP\mydev-tools-personal"

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File "https://rubygems.org/gems/rubygems-update-2.6.11.gem" "$downloadPath\rubygems.gem"

gem install --local "$downloadPath\rubygems.gem"

update_rubygems

gem install jekyll

Write-Output " Installing SearchMyFiles manually since the community package hasn't been updated..."

$url = 'http://www.nirsoft.net/utils/searchmyfiles-x64.zip'
$url64 = 'http://www.nirsoft.net/utils/searchmyfiles-x64.zip'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installFile = Join-Path $toolsDir "searchmyfiles.exe"

Install-ChocolateyZipPackage -PackageName "searchmyfiles" `
                             -Url "$url" `
                             -UnzipLocation "$toolsDir" `
                             -Url64bit "$url64"
