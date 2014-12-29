$packageName = "plantuml"
$url = "http://sourceforge.net/projects/plantuml/files/plantuml.jar/download"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
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

    $shimgen = "$env:ChocolateyInstall\chocolateyinstall\tools\shimgen.exe"

    & $shimgen -o "$env:ChocolateyInstall\bin\plantuml.bat" -p "$appDir\plantuml.bat"

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
