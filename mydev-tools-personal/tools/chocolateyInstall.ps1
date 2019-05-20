$Script:UbuntuVersion = 1804

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

Write-Output "Downloading and installing Ubuntu $($Script:UbuntuVersion)..."

Push-Location -Path $env:TEMP

Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-$Script:UbuntuVersion -OutFile Ubuntu.appx -UseBasicParsing

Rename-Item Ubuntu.appx Ubuntu.zip

if (Test-Path $env:SYSTEMDRIVE\Ubuntu) {
    Remove-Item -Path $env:SYSTEMDRIVE\Ubuntu -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $env:SYSTEMDRIVE\Ubuntu | Out-Null

Expand-Archive Ubuntu.zip $env:SYSTEMDRIVE\Ubuntu

Set-Content $env:SYSTEMDRIVE\Ubuntu\desktop.ini @"
[.ShellClassInfo]
IconResource=$env:SYSTEMDRIVE\Ubuntu\ubuntu$Script:UbuntuVersion.exe,0
"@

attrib +S +H $env:SYSTEMDRIVE\Ubuntu\desktop.ini
attrib +S $env:SYSTEMDRIVE\Ubuntu

Write-Output "Ubuntu Linux has been installed...  Starting final install."

Pop-Location

Remove-Item -Path $env:TEMP\ubuntu.zip -Force | Out-Null

Start-Process -FilePath $env:SYSTEMDRIVE\Ubuntu\ubuntu$Script:UbuntuVersion.exe `
    -ArgumentList "--root" -NoNewWindow -Wait
