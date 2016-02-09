$packageName = "cs-script"
$url = "https://csscriptsource.codeplex.com/downloads/get/1544890"

$downloadPath = "$env:TEMP\chocolatey\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

$mklink = "cmd.exe /c mklink"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (-not (Test-Path $downloadPath)) {
    New-Item -Type Directory -Path $downloadPath | Out-Null
}

Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.7z" $url $url
Get-ChocolateyUnzip "$downloadPath\$packageName.7z" "$downloadPath\"

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item -Path $appDir -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Copy-Item -Path "$downloadPath\$packageName\*" -Destination "$appDir\"

$cmd = "$mklink '${env:ChocolateyInstall}\bin\cscs.exe' '$appDir\cscs.exe'"

if (Test-ProcessAdminRights) {
    Invoke-Expression $cmd
} else {
    Start-ChocolateyProcessAsAdmin $cmd
}
