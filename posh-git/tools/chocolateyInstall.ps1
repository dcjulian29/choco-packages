$packageName = "posh-git"
$release = "0.7.0"
$url = "https://github.com/dahlbyk/posh-git/archive/v$($release).zip"
$appDir = "$($env:UserProfile)\Documents\WindowsPowerShell\Modules\$packageName"
$downloadPath = "$env:TEMP\$packageName"

if (-not (Test-Path $downloadPath))
{
    New-Item -Type Directory -Path $downloadPath | Out-Null
}

Download-File $url "$downloadPath\v$release.zip"
Unzip-File "$downloadPath\v$release.zip" "$downloadPath\"

if (Test-Path $appDir)
{
    Write-Output "Removing previous version of package..."
    Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Copy-Item -Path "$downloadPath\$packageName-$release\src\*" -Destination "$appDir"
