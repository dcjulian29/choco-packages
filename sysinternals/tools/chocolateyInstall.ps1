$packageName = 'sysinternals'
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"
$url = 'https://download.sysinternals.com/files/SysinternalsSuite.zip'

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (-not (Test-Path $downloadPath)) {
    New-Item -Type Directory -Path $downloadPath | Out-Null
}

Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url $url
Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"

if (Test-Path $appDir)
{
  Write-Output "Removing previous version of package..."
  Remove-Item "$($appDir)\*" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Get-ChildItem -Path $downloadPath -Exclude "$packageName.zip" | Copy-Item -Destination "$appDir"
    

if (Test-ProcessAdminRights) {
    . $toolDir\postInstall.ps1
} else {
    Start-ChocolateyProcessAsAdmin ". $toolDir\postInstall.ps1"
}
