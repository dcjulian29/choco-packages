$packageName = "myscripts-powershell"
$appDir = "$($env:UserProfile)\Documents\WindowsPowerShell"

$version = "2016.9.23.1"
$repo = "scripts-powershell"
$url = "https://github.com/dcjulian29/$repo/archive/$version.zip"

$file = "$repo-$version"

if (Test-Path "$env:TEMP\$file") {
    Remove-Item "$env:TEMP\$file" -Recurse -Force
}

(New-Object System.Net.WebClient).DownloadFile("$url", "$env:TEMP\$file.zip")

[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory("$env:TEMP\$file.zip", $env:TEMP)

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

Get-ChildItem -Path "$($env:TEMP)\$file" -Recurse |
    Where-Object { $_.FullName -notlike "*\MyModules" } |
    Where-Object { $_.FullName -notlike "*\MyModules\*" } |
    Where-Object { $_.FullName -notlike "*Test-Scripts.ps1" } |
    Where-Object { $_.FullName -notlike "*README.md" } |
    Copy-Item -Force -Destination { $_.FullName -replace [regex]::Escape("$($env:TEMP)\$file"), $appdir }

if (Test-Path "$env:APPDATA\PowerShellModules") {
    # Previous versions of my powershell profile/module would store modules here.
    # This is no longer the correct location so modules here need to be moved.
    Move-Item -Path "$env:APPDATA\PowerShellModules" -Destination "$appdir\Modules"
}
