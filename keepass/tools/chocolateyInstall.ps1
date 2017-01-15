$packageName = "keepass"
$url = "https://julianscorner.com/downloads/KeePass-2.35.zip"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (-not (Test-Path $downloadPath))
{
    New-Item -Type Directory -Path $downloadPath | Out-Null
}

Get-ChocolateyWebFile $packageName "$downloadPath\keepass.zip" $url

if (Test-Path $appDir)
{
    Copy-Item "$($appDir)\KeePass.config.xml" "$downloadPath\KeePass.config.xml"
    Write-Output "Removing previous version of package..."
    Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Get-ChocolateyUnzip "$downloadPath\keepass.zip" "$appDir\"

if (Test-Path "$downloadPath\KeePass.config.xml")
{
    Write-Output "Migrating previous configuration..."
    Copy-Item "$downloadPath\KeePass.config.xml" "$($appDir)\KeePass.config.xml"
}
