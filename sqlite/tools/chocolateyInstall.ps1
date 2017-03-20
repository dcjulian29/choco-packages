$packageName = "sqlite"
$url = "https://www.sqlite.org/2017/sqlite-tools-win32-x86-3170000.zip"
$downloadPath = "$env:LOCALAPPDATA\Temp\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\$($packageName)"

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.zip"

Unzip-File "$downloadPath\$packageName.zip" "$downloadPath\"

if (Test-Path $appDir)
{
    Write-Output "Removing previous version of package..."
    Remove-Item "$($appDir)" -Recurse -Force
}

Copy-Item -Path "$($downloadPath)\sqlite*\*.exe" -Destination "$appDir" -Recurse

Invoke-ElevatedCommand "cmd.exe" `
    -ArgumentList "/c mklink '$env:ChocolateyInstall\bin\sqlite3.exe' '$appDir\sqlite3.exe'" `
    -Wait

Invoke-ElevatedCommand "cmd.exe" `
    -ArgumentList "/c mklink '$env:ChocolateyInstall\bin\sqlite3_analyzer.exe' '$appDir\sqlite3_analyzer.exe'" `
    -Wait

Invoke-ElevatedCommand "cmd.exe" `
    -ArgumentList "/c mklink '$env:ChocolateyInstall\bin\sqldiff.exe' '$appDir\sqldiff.exe'" `
    -Wait
