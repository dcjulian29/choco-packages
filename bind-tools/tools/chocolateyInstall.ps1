$packageName = "bind-tools"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$appDir = "$($env:ChocolateyInstall)\apps\$($packageName)"

$url = "http://ftp.isc.org/isc/bind9/9.9.4-P2/BIND9.9.4-P2.zip"

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
    $ErrorActionPreference = "Stop"
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

    Get-ChocolateyWebFile $packageName "$downloadPath\bind.zip" $url
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
