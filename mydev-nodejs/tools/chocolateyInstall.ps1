$packageName = "mydev-nodejs"

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
