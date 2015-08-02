$packageName = "myscripts-development"
$appDir = "$($env:SYSTEMDRIVE)\tools\development"
$version = "2015.7.30"
$repo = "scripts-development"
$url = "https://github.com/dcjulian29/$repo/archive/$version.zip"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Test-Path $appDir)
{
    Write-Output "Removing previous version of package..."
    Remove-Item "$($appDir)\*" -Recurse -Force
}

if (-not (Test-Path $appDir))
{
    New-Item -Type Directory -Path $appDir | Out-Null
}

$file = "$repo-$version"

(New-Object System.Net.WebClient).DownloadFile("$url", "$env:TEMP\$file.zip")

[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory("$env:TEMP\$file.zip", $env:TEMP)

Copy-Item -Path "$($env:TEMP)\$file\*" -Destination $appdir -Recurse -Force

Remove-Item -Path "$($env:TEMP)\$file" -Recurse -Force
Remove-Item -Path "$($env:TEMP)\$file.zip" -Force
