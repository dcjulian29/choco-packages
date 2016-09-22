$packageName = "myscripts-powershell"
$appDir = "$($env:SYSTEMDRIVE)\tools\powershell"
$version = "2016.9.22"
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

$user = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())

if (($user.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) -eq $false)  {
    Invoke-Expression $cmd
} else {
    $process = New-Object System.Diagnostics.ProcessStartInfo "$PSScriptRoot\postInstall.bat"
    $process.Verb = "runas"

    $handle = [System.Diagnostics.Process]::Start($process)
    $handle.WaitForExit()
}
