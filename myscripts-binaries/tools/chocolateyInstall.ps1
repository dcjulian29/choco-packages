$packageName = "myscripts-binaries"
$appDir = "$($env:SYSTEMDRIVE)\tools\binaries"
$version = "2016.11.4.1"
$repo = "scripts-binaries"
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

if (-not ($($env:PATH).ToLowerInvariant().Contains("$($env:SYSTEMDRIVE)\tools\binaries".ToLowerInvariant()))) {
    Invoke-ElevatedExpression "cmd.exe /c 'setx /m PATH $($env:SYSTEMDRIVE)\tools\binaries;$($env:PATH)'"
}
