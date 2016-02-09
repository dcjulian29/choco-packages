$packageName = "bind-tools"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

$url = "http://ftp.isc.org/isc/bind9/9.10.3-P3/BIND9.10.3-P3.x86.zip"
$url64 = "http://ftp.isc.org/isc/bind9/9.10.3-P3/BIND9.10.3-P3.x64.zip"

$installArgs = "/install /passive /norestart"
$vcredist = "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe"
$vcredist64 = "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe"

$keep = @(
  "dig.exe",
  "host.exe",
  "libbind9.dll",
  "libdns.dll",
  "libeay32.dll",
  "libisc.dll",
  "libisccfg.dll",
  "liblwres.dll",
  "libxml2.dll"
)

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

if (-not (Test-Path "HKLM:SOFTWARE\Microsoft\DevDiv\vc\Servicing\11.0")) {
    Install-ChocolateyPackage "vcredist2012" "EXE" $installArgs $vcredist $vcredist64
}

Get-ChocolateyWebFile $packageName "$downloadPath\bind.zip" $url $url64
Get-ChocolateyUnzip "$downloadPath\bind.zip" "$downloadPath\"

if (Test-Path $appDir)
{
  Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Get-ChildItem -Path $downloadPath -Include $keep -Recurse | Copy-Item -Destination "$appDir"
