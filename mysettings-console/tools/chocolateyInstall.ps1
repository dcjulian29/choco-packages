$url = "https://codeload.github.com/mbadolato/iTerm2-Color-Schemes/zip/master"

if (Test-Path $env:TEMP\iTerm2-Color-Schemes.zip) {
    Remove-Item $env:TEMP\iTerm2-Color-Schemes.zip -Force
}

Download-File $url $env:TEMP\iTerm2-Color-Schemes.zip

if (Test-Path $env:TEMP\iTerm2-Color-Schemes-master) {
    Remove-Item $env:TEMP\iTerm2-Color-Schemes-master -Recurse -Force
}

Unzip-File $env:TEMP\iTerm2-Color-Schemes.zip $env:TEMP\

Copy-Item -Path $env:TEMP\iTerm2-Color-Schemes-master\schemes\* `
    -Destination $env:ChocolateyInstall\lib\colortool\content\schemes\ `
    -Recurse -Force

$cmd = "$env:WINDIR\system32\reg.exe import $PSScriptRoot\registry.reg"

if ([System.IntPtr]::Size -ne 4) {
    $cmd = "$cmd /reg:64"
}

cmd /c "$cmd"

ColorTool.exe -b purplepeter.itermcolors
