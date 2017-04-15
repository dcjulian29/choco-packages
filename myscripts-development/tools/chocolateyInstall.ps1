$packageName = "myscripts-development"
$appDir = "$($env:SYSTEMDRIVE)\tools\development"
$version = "${env:ChocolateyPackageVersion}"
$repo = "scripts-development"
$url = "https://github.com/dcjulian29/$repo/archive/$version.zip"
$file = "$repo-$version"
$downloadPath = "$env:LOCALAPPDATA\Temp\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File -Url $url -Destination "$downloadPath\$file.zip"

Unzip-File -File "$downloadPath\$file.zip" -Destination $downloadPath

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item $appDir -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Copy-Item -Path "$downloadPath\$file\*" -Destination $appdir -Recurse -Force

Remove-Item -Path "$downloadPath\$file" -Recurse -Force
Remove-Item -Path "$downloadPath\$file.zip" -Force
