$packageName = "octopusdeploy"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

$url = "https://download.octopusdeploy.com/octopus-tools/3.4.2/OctopusTools.3.4.2.zip"

$keep = @(
  "octo.exe",
  "octo.exe.config"
)

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url $url
Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"

if (Test-Path $appDir)
{
  Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Get-ChildItem -Path $downloadPath -Include $keep -Recurse | Copy-Item -Destination "$appDir"
