$packageName = "outlookstatview"
$url = "http://www.nirsoft.net/utils/outlookstatview.zip"
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
Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$appDir\"
