$packageName = "sqlite"
$url = "https://www.sqlite.org/2016/sqlite-tools-win32-x86-3120200.zip"

$downloadPath = "$($env:TEMP)\chocolatey\$($packageName)"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Test-Path $appDir)
{
    Write-Output "Removing previous version of package..."
    Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null
    
if (Test-Path $downloadPath)
{
    Remove-Item "$($downloadPath)" -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Get-ChocolateyWebFile $packageName "$downloadPath\sqlite.zip" $url

Get-ChocolateyUnzip "$downloadPath\sqlite.zip" "$downloadPath"

Copy-Item -Path "$($downloadPath)\sqlite*\*.exe" -Destination "$appDir" -Recurse

if (Test-ProcessAdminRights) {
    cmd /c mklink "$env:ChocolateyInstall\bin\sqlite3.exe" "$appDir\sqlite3.exe"
} else {
    Start-ChocolateyProcessAsAdmin "cmd /c mklink '$env:ChocolateyInstall\bin\sqlite3.exe' '$appDir\sqlite3.exe'"
}

if (Test-ProcessAdminRights) {
    cmd /c mklink /J "$env:ChocolateyInstall\bin\sqlite3_analyzer.exe" "$appDir\sqlite3_analyzer.exe"
} else {
    Start-ChocolateyProcessAsAdmin "cmd /c mklink /J '$env:ChocolateyInstall\bin\sqlite3_analyzer.exe' '$appDir\sqlite3_analyzer.exe'"
}

if (Test-ProcessAdminRights) {
    cmd /c mklink "$env:ChocolateyInstall\bin\sqldiff.exe" "$appDir\sqldiff.exe"
} else {
    Start-ChocolateyProcessAsAdmin "cmd /c mklink '$env:ChocolateyInstall\bin\sqldiff.exe' '$appDir\sqldiff.exe'"
}
