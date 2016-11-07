$packageName = "searchmyfiles"
$url = "http://www.nirsoft.net/utils/searchmyfiles.zip"
$url64 = "http://www.nirsoft.net/utils/searchmyfiles-x64.zip"
$downloadPath = "$env:TEMP\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if ([System.IntPtr]::Size -ne 4) {
    $url = $url64
}

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.zip"

if (Test-Path $appDir)
{
    Write-Output "Removing previous version of package..."
    Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Unzip-File "$downloadPath\$packageName.zip" "$appDir\"

