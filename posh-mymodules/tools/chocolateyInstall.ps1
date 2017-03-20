$packageName = "posh-mymodules"
$appDir = "$($env:UserProfile)\Documents\WindowsPowerShell\MyModules"

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

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item "$($appDir)\*" -Recurse -Force
}

if (-not (Test-Path $appDir)) {
    New-Item -Type Directory -Path $appDir | Out-Null
}

Copy-Item -Path "$($env:LOCALAPPDATA)\$file\MyModules\*" -Destination $appdir -Recurse -Force

# Make sure modules are loaded and available for this and future sessions...
$PSModulePath = "$(Split-Path $profile)\Modules"
$PSModulePath = "$(Split-Path $profile)\MyModules;$PSModulePath"

if ((-not ($env:PSModulePath).Contains("$(Split-Path $profile)\MyModules"))) {
    $env:PSModulePath = "$(Split-Path $profile)\MyModules;$($env:PSModulePath)"

    Get-Module -ListAvailable | Out-Null

    Invoke-ElevatedExpression "[Environment]::SetEnvironmentVariable('PSModulePath', '$PSModulePath', 'User')"

    $env:PSModulePath = "$PSModulePath;$($env:PSModulePath)"
} 
