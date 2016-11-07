$packageName = "nmap"
$version = "7.31"
$url = "https://nmap.org/dist/nmap-$($version)-win32.zip"
$downloadPath = "$env:TEMP\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.zip"

Unzip-File "$downloadPath\$packageName.zip" "$downloadPath\"

if (Test-Path $appDir)
{
    Write-Output "Removing previous version of package..."
    Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Copy-Item -Path "$($downloadPath)\nmap-$($version)\*" -Destination "$appDir" -Recurse -Container

$cmd = "$env:WINDIR\system32\reg.exe import $appDir\nmap_performance.reg"

if ([System.IntPtr]::Size -ne 4) {
    $cmd = "$cmd /reg:64"
}

Invoke-ElevatedExpression $cmd
