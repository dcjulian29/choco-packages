$packageName = "mydev-ruby"
$downloadPath = "$env:LOCALAPPDATA\Temp\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File "https://rubygems.org/gems/rubygems-update-2.6.11.gem" "$downloadPath\rubygems.gem"

gem install --local "$downloadPath\rubygems.gem"

update_rubygems

gem install jekyll
