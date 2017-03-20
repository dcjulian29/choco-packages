$packageName = "posh-myprofile"
$appDir = "$($env:UserProfile)\Documents\WindowsPowerShell"

$version = "${env:ChocolateyPackageVersion}"
$repo = "scripts-powershell"
$url = "https://github.com/dcjulian29/$repo/archive/$version.zip"

$file = "$repo-$version"

if (Test-Path "$env:LOCALAPPDATA\$file") {
    Remove-Item "$env:LOCALAPPDATA\$file" -Recurse -Force
}

(New-Object System.Net.WebClient).DownloadFile("$url", "$env:LOCALAPPDATA\$file.zip")

[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory("$env:LOCALAPPDATA\$file.zip", $env:LOCALAPPDATA)

if (Test-Path "$appDir\Profile.ps1") {
    Write-Output "Removing previous version of package..."
    Get-ChildItem -Path $appDir -Recurse |
        Select -ExpandProperty FullName |
        Where-Object { $_ -notlike "$appdir\Modules*" } |
        Where-Object { $_ -notlike "$appdir\MyModules*" } |
        Sort-Object Length -Descending |
        Remove-Item -Force
}

if (-not (Test-Path $appDir))
{
    New-Item -Type Directory -Path $appDir | Out-Null
}

Get-ChildItem -Path "$($env:LOCALAPPDATA\Temp)\$file" -Recurse |
    Where-Object { $_.FullName -notlike "*\MyModules" } |
    Where-Object { $_.FullName -notlike "*\MyModules\*" } |
    Where-Object { $_.FullName -notlike "*Test-Scripts.ps1" } |
    Where-Object { $_.FullName -notlike "*README.md" } |
    Copy-Item -Force -Destination { $_.FullName -replace [regex]::Escape("$($env:LOCALAPPDATA)\$file"), $appdir }
