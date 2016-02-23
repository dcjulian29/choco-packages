$packageName = "balsamiq"
$url = "https://build_archives.s3.amazonaws.com/mockups-desktop/Balsamiq_Mockups_3.3.9_bundled.zip"

$downloadPath = "$($env:TEMP)\chocolatey\$($packageName)"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Test-Path $downloadPath)
{
    Remove-Item -Path $downloadPath -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url

if (Test-Path $appDir)
{
    Write-Output "Removing previous version of package..."
    Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"

Copy-Item -Path "$($downloadPath)\Balsamiq*\*" -Destination "$appDir" -Recurse
