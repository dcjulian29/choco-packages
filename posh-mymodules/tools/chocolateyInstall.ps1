$appDir = "$($env:UserProfile)\Documents\WindowsPowerShell\MyModules"
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

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item "$($appDir)\*" -Recurse -Force
}

if (-not (Test-Path $appDir)) {
    New-Item -Type Directory -Path $appDir | Out-Null
}

Copy-Item -Path "$downloadPath\$file\MyModules\*" -Destination $appdir -Recurse -Force

# Make sure modules are loaded and available for this and future sessions...
if ((-not ($env:PSModulePath).Contains("$(Split-Path $profile)\MyModules"))) {
    $PSModulePath = "$(Split-Path $profile)\MyModules;$($env:PSModulePath)"

    $env:PSModulePath = $PSModulePath

    Get-Module -ListAvailable | Out-Null

    Invoke-Expression "[Environment]::SetEnvironmentVariable('PSModulePath', '$PSModulePath', 'User')"
}
