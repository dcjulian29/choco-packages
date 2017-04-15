$packageName = "myscripts-binaries"
$appDir = "$($env:SYSTEMDRIVE)\tools\binaries"
$version = "${env:ChocolateyPackageVersion}"
$repo = "scripts-binaries"
$url = "https://github.com/dcjulian29/$repo/archive/$version.zip"
$file = "$repo-$version"
$downloadPath = "$env:LOCALAPPDATA\Temp\$packageName"

if (-not (Test-Path $downloadPath)) {
    New-Item -Type Directory -Path $downloadPath | Out-Null
}

Download-File -Url $url -Destination "$downloadPath\$file.zip"

Unzip-File -File "$downloadPath\$file.zip" -Destination $downloadPath

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item $appDir -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Copy-Item -Path "$($downloadPath)\$file\*" -Destination $appdir -Recurse -Force

Remove-Item -Path "$($downloadPath)\$file" -Recurse -Force
Remove-Item -Path "$($downloadPath)\$file.zip" -Force

if (-not ($($env:PATH).ToLowerInvariant().Contains("$($env:SYSTEMDRIVE)\tools\binaries".ToLowerInvariant()))) {
    Invoke-ElevatedExpression "cmd.exe /c 'setx /m PATH $($env:SYSTEMDRIVE)\tools\binaries;$($env:PATH)'"
}
