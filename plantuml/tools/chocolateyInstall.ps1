$packageName = "plantuml"
$url = "https://julianscorner.com/downloads/plantuml.8045.jar"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item -Path $appDir -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Get-ChocolateyWebFile $packageName "$appDir\$packageName.jar" $url

Set-Content -Path "$appDir\plantuml.bat" -Value @"
@echo off

setlocal
 
set DIR=%~dp0%

set GRAPHVIZ_DOT=%SYSTEMDRIVE%\tools\apps\graphviz\bin\dot.exe

path %SYSTEMDRIVE%\tools\apps\graphviz\bin;%JAVA_HOME%\bin;%PATH% 

java -jar %DIR%\plantuml.jar %*

endlocal
"@

if (Test-ProcessAdminRights) {
    . $toolDir\postInstall.ps1
} else {
    Start-ChocolateyProcessAsAdmin ". $toolDir\postInstall.ps1"
}
