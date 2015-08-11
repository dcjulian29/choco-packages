$packageName = "bind-tools"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

$url = "http://ftp.isc.org/isc/bind9/9.10.2/BIND9.10.2.x86.zip"
$url64 = "http://ftp.isc.org/isc/bind9/9.10.2/BIND9.10.2.x64.zip"

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

try
{
    if (Test-Path $appDir)
    {
      Remove-Item "$($appDir)" -Recurse -Force
    }

    if (-not (Test-Path $downloadPath)) {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Get-ChocolateyWebFile $packageName "$downloadPath\bind.zip" $url $url64
    Get-ChocolateyUnzip "$downloadPath\bind.zip" "$downloadPath\"

    if (-not (Test-Path $appDir)) {
        New-Item -Type Directory -Path $appDir | Out-Null
    }

    Get-ChildItem -Path $downloadPath -Include $keep -Recurse | Copy-Item -Destination "$appDir"

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
