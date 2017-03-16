$packageName = "ipscan"
$url = "https://github.com/angryziber/ipscan/releases/download/3.5.1/ipscan-win32-3.5.1.exe"
$url64 = "https://github.com/angryziber/ipscan/releases/download/3.5.1/ipscan-win64-3.5.1.exe"
$downloadPath = "$env:TEMP\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if ([System.IntPtr]::Size -ne 4) {
    $url = $url64
}

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.exe"

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Get-ChildItem -Path $downloadPath\$packagename.exe | Copy-Item -Destination "$appDir\"
