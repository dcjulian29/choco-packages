$packageName = "posh-myprofile"
$appDir = "$($env:UserProfile)\Documents\WindowsPowerShell"
$downloadPath = "$env:LOCALAPPDATA\Temp"

$version = "${env:ChocolateyPackageVersion}"
$repo = "scripts-powershell"
$url = "https://github.com/dcjulian29/$repo/archive/$version.zip"

$file = "$repo-$version"

if (Test-Path "$downloadPath\$file") {
    Remove-Item "$downloadPath\$file" -Recurse -Force
}

(New-Object System.Net.WebClient).DownloadFile("$url", "$downloadPath\$file.zip")

[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory("$downloadPath\$file.zip", $downloadPath)

if (Test-Path "$appDir\Profile.ps1") {
    Write-Output "Removing previous version of package..."
    Get-ChildItem -Path $appDir -Recurse |
        Select -ExpandProperty FullName |
        Where-Object { $_ -notlike "$appdir\Modules*" } |
        Where-Object { $_ -notlike "$appdir\MyModules*" } |
        Sort-Object Length -Descending |
        Remove-Item -Force
}

if (-not (Test-Path $appDir)) {
    New-Item -Type Directory -Path $appDir | Out-Null
}

Get-ChildItem -Path "$downloadPath\$file" -Recurse |
    Where-Object { $_.FullName -notlike "*\MyModules" } |
    Where-Object { $_.FullName -notlike "*\MyModules\*" } |
    Where-Object { $_.FullName -notlike "*Test-Scripts.ps1" } |
    Where-Object { $_.FullName -notlike "*README.md" } |
    Copy-Item -Force -Destination { $_.FullName -replace [regex]::Escape("$downloadPath\$file"), $appdir }

if (-not (Test-Path "$(Split-Path $profile)\Modules")) {
    New-Item -Type Directory -Path "$(Split-Path $profile)\Modules" | Out-Null
}

if ((-not ($env:PSModulePath).Contains("$(Split-Path $profile)\Modules"))) {
    $env:PSModulePath = "$(Split-Path $profile)\Modules;$($env:PSModulePath)"

    Get-Module -ListAvailable | Out-Null

    Invoke-Expression "[Environment]::SetEnvironmentVariable('PSModulePath', '$PSModulePath', 'User')"
} 
