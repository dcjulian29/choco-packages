$packageName = "php"
$version = "7.0.2"
$url = "http://windows.php.net/downloads/releases/php-$version-nts-Win32-VC14-x86.zip"
$url64 = "http://windows.php.net/downloads/releases/php-$version-nts-Win32-VC14-x64.zip" 
$installArgs = "/install /passive /norestart"
$vcredist = "https://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x86.exe"
$vcredist64 = "https://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x64.exe"

$downloadPath = "$env:TEMP\chocolatey\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

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


if (-not (Test-Path "HKLM:SOFTWARE\Microsoft\DevDiv\vc\Servicing\14.0")) {
    Install-ChocolateyPackage "vcredist2015" "EXE" $installerArgs $vcredist $vcredist64
}

Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url $url64
Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$appDir\"

Copy-Item "$appDir\php.ini-production" "$appDir\php.ini"
