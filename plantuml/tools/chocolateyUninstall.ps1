$packageName = "plantuml"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if (Test-Path "${env:ChocolateyInstall}\bin\plantuml.bat") {
    Remove-Item "${env:ChocolateyInstall}\bin\plantuml.bat" -Force
}
    
if (Test-Path $appDir) {
  Remove-Item "$($appDir)" -Recurse -Force
}

