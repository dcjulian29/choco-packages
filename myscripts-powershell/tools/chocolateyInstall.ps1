$packageName = "myscripts-powershell"
$appDir = "$($env:SYSTEMDRIVE)\tools\powershell"
$version = "2016.9.20"
$repo = "scripts-powershell"
$url = "https://github.com/dcjulian29/$repo/archive/$version.zip"

$file = "$repo-$version"

(New-Object System.Net.WebClient).DownloadFile("$url", "$env:TEMP\$file.zip")

[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory("$env:TEMP\$file.zip", $env:TEMP)

if (Test-Path $appDir\Modules) {
    cmd /c rmdir "$appdir\Modules"
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

Copy-Item -Path "$($env:TEMP)\$file\*" -Destination $appdir -Recurse -Force

Remove-Item -Path "$($env:TEMP)\$file" -Recurse -Force
Remove-Item -Path "$($env:TEMP)\$file.zip" -Force

$cmd = ". $PSScriptRoot\postInstall.bat"

if (Test-ProcessAdminRights) {
    Invoke-Expression $cmd
} else {
    Start-Process $PSHOME\powershell.exe `
        -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-Command `"&{$cmd}`"" `
        -Wait
}
