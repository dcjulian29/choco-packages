$packageName = "docker"
$url = "https://get.docker.com/builds/Windows/i386/docker-1.11.2.zip"
$url64 = "https://get.docker.com/builds/Windows/x86_64/docker-1.11.2.zip"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$mklink = "cmd.exe /c mklink"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if (Test-Path $downloadPath)
{
    Remove-Item -Path $downloadPath -Force -Recurse | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Get-ChocolateyWebFile $packageName "$downloadPath\$packageName.zip" $url $url64
Get-ChocolateyUnzip "$downloadPath\$packageName.zip" "$downloadPath\"

if (Test-Path $appDir)
{
  Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Get-ChildItem -Path "$downloadPath\docker" | Copy-Item -Destination "$appDir"

if (Test-Path "${env:ChocolateyInstall}\bin\docker.exe") {
    $cmd = "(Get-Item '${env:ChocolateyInstall}\bin\docker.exe').Delete()"

    if (Test-ProcessAdminRights) {
        Invoke-Expression $cmd
    } else {
        Start-ChocolateyProcessAsAdmin $cmd
    }
}

$cmd = "$mklink '${env:ChocolateyInstall}\bin\docker.exe' '$appDir\docker.exe'"

if (Test-ProcessAdminRights) {
    Invoke-Expression $cmd
} else {
    Start-ChocolateyProcessAsAdmin $cmd
}
