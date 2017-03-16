$packageName = "posh-mymodules"
$appDir = "$($env:UserProfile)\Documents\WindowsPowerShell\MyModules"

$version = "2017.3.25.1"
$repo = "scripts-powershell"
$url = "https://github.com/dcjulian29/$repo/archive/$version.zip"

$file = "$repo-$version"

if (Test-Path "$env:TEMP\$file") {
    Remove-Item "$env:TEMP\$file" -Recurse -Force
}

(New-Object System.Net.WebClient).DownloadFile("$url", "$env:TEMP\$file.zip")

[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory("$env:TEMP\$file.zip", $env:TEMP)

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item "$($appDir)\*" -Recurse -Force
}

if (-not (Test-Path $appDir)) {
    New-Item -Type Directory -Path $appDir | Out-Null
}

Copy-Item -Path "$($env:TEMP)\$file\MyModules\*" -Destination $appdir -Recurse -Force

# Make sure modules are loaded and available for this and future sessions...
$PSModulePath = "$(Split-Path $profile)\Modules"
$PSModulePath = "$(Split-Path $profile)\MyModules;$PSModulePath"

if ((-not ($env:PSModulePath).Contains("$(Split-Path $profile)\MyModules"))) {
    $env:PSModulePath = "$(Split-Path $profile)\MyModules;$($env:PSModulePath)"

    Get-Module -ListAvailable | Out-Null

    Invoke-ElevatedExpression "[Environment]::SetEnvironmentVariable('PSModulePath', '$PSModulePath', 'User')"

    $env:PSModulePath = "$PSModulePath;$($env:PSModulePath)"
} 
