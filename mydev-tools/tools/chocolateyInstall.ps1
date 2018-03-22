$packageName = "mydev-tools"

# Node.JS tools

$npm = "$($env:ProgramFiles)\nodejs\npm.cmd"
    
& $npm install -g bower
& $npm install -g gulp grunt-cli
& $npm install -g yo 
& $npm install -g generator-aspnet generator-express
& $npm install -g generator-hottowel generator-meanjs generator-sails-rest-api
& $npm install -g generator-hubot
& $npm install -g csslint
& $npm install -g jslint jshint
& $npm install -g typescript
& $npm install -g pm2

# Ruby Tools

$downloadPath = "$env:LOCALAPPDATA\Temp\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File "https://rubygems.org/gems/rubygems-update-2.6.11.gem" "$downloadPath\rubygems.gem"

gem install --local "$downloadPath\rubygems.gem"

update_rubygems

gem install jekyll