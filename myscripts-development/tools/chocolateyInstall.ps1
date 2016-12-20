$packageName = "myscripts-development"
$appDir = "$($env:SYSTEMDRIVE)\tools\development"
$version = "2016.12.19.1"
$repo = "scripts-development"
$url = "https://github.com/dcjulian29/$repo/archive/$version.zip"
$file = "$repo-$version"

Download-File -Url $url -Destination "$env:TEMP\$file.zip"

Unzip-File -File "$env:TEMP\$file.zip" -Destination $env:TEMP

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item $appDir -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Copy-Item -Path "$($env:TEMP)\$file\*" -Destination $appdir -Recurse -Force

Remove-Item -Path "$($env:TEMP)\$file" -Recurse -Force
Remove-Item -Path "$($env:TEMP)\$file.zip" -Force
