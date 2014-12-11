$packageName = "mydev-nodejs"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    $npm = "$($env:ProgramFiles)\nodejs\npm.cmd"
    
    & $npm install -g bower
    & $npm install -g gulp grunt-cli
    & $npm install -g yo generator-hottowel
    & $npm install -g csslint
    & $npm install -g jslint jshint
    & $npm install -g node-inspector
    & $npm install -g typescript

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
