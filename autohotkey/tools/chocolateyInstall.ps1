$packageName = 'autohotkey'
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$url = "https://autohotkey.com/download/1.1/AutoHotkey_1.1.24.02.zip"
$downloadPath = "$env:TEMP\$packageName"

$keep = @(
  "AutoHotkey.chm",
  "AutoHotkeyU32.exe",
  "AutoHotkeyU64.exe",
  "Ahk2Exe.exe",
  "Unicode 32-bit.bin",
  "Unicode 64-bit.bin"
)

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.zip"

Unzip-File "$downloadPath\$packageName.zip" "$downloadPath\"

if (Test-Path $appDir)
{
  Write-Output "Removing previous version of package..."
  Remove-Item $appDir -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Get-ChildItem -Path $downloadPath -Include $keep -Recurse | Copy-Item -Destination $appDir

if (Test-Path "${env:ChocolateyInstall}\bin\ahk.exe") {
    $cmd = "(Get-Item '${env:ChocolateyInstall}\bin\ahk.exe').Delete()"

    Invoke-ElevatedExpression $cmd
}

$mklink = "cmd.exe /c mklink"

$cmd = "$mklink '${env:ChocolateyInstall}\bin\ahk.exe' '$appDir\AutoHotkeyU32.exe'"

if ([System.IntPtr]::Size -ne 4) {
    $cmd = "$mklink '${env:ChocolateyInstall}\bin\ahk.exe' '$appDir\AutoHotkeyU64.exe'"
}

Invoke-ElevatedExpression $cmd
