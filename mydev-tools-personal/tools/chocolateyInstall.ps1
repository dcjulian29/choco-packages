$downloadPath = "$env:TEMP\mydev-tools-personal"

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

# Download-File "https://rubygems.org/downloads/rubygems-update-3.1.4.gem" "$downloadPath\rubygems.gem"

# gem install --local "$downloadPath\rubygems.gem"

# update_rubygems

# ridk install 3
# gem install bundler
# gem install jekyll
