$packageName = "plantuml"
$version = "8050"
$url = "https://julianscorner.com/downloads/plantuml.$version.jar"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item -Path $appDir -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Download-File $url "$appDir\$packageName.jar"

Set-Content -Path "$env:ChocolateyInstall\bin\plantuml.bat" -Value @"
@echo off

setlocal
 
set GRAPHVIZ_DOT=%SYSTEMDRIVE%\tools\apps\graphviz\bin\dot.exe

path %SYSTEMDRIVE%\tools\apps\graphviz\bin;%JAVA_HOME%\bin;%PATH% 

java -jar $appDir\plantuml.$version.jar %*

endlocal
"@
