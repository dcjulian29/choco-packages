$packageName = "nmap"
$version = "7.01"
$url = "https://nmap.org/dist/nmap-$($version)-win32.zip"

$downloadPath = "$env:TEMP\chocolatey\$packageName"
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

if (-not (Test-Path $downloadPath))
{
    New-Item -Type Directory -Path $downloadPath | Out-Null
}

Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url
Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"

Copy-Item -Path "$($downloadPath)\nmap-$($version)\*" -Destination "$appDir" -Recurse -Container

$cmd = "$env:WINDIR\system32\reg.exe import $appDir\nmap_performance.reg"

if (Get-ProcessorBits -eq 64) {
    $cmd = "$cmd /reg:64"
}

Start-ChocolateyProcessAsAdmin "$cmd"
