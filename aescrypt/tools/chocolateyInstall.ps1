$packageName = "aescrypt"
$url = "http://www.aescrypt.com/download/v3/windows/AESCrypt_console_v310_win32.zip"
$url64 = "http://www.aescrypt.com/download/v3/windows/AESCrypt_console_v310_x64.zip"

$downloadPath = "$($env:TEMP)\chocolatey\$($packageName)"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Test-Path $appDir) {
  Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

if (-not (Test-Path $downloadPath)) {
    New-Item -Type Directory -Path $downloadPath | Out-Null
}

Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url $url64
Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"

Get-ChildItem "$downloadPath\AESC*\*" | Copy-Item -Destination "$appDir"

if (Test-ProcessAdminRights) {
    . $toolDir\postInstall.ps1
} else {
    Start-ChocolateyProcessAsAdmin ". $toolDir\postInstall.ps1"
}
