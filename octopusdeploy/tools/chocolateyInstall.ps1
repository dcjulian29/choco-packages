$packageName = "octopusdeploy"
$downloadPath = "$env:TEMP\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

$url = "https://download.octopusdeploy.com/octopus-tools/4.5.3/OctopusTools.4.5.3.zip"

if (Test-Path $downloadPath) {
    Remove-Item $downloadPath -Recurse -Force | Out-Null
}

New-Item -Type Directory -Path $downloadPath | Out-Null

$file = "$downloadPath\$packageName.zip"

Download-File $url $file
Unzip-File $file $downloadPath

if (Test-Path $appDir)
{
  Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null

Copy-Item -Path $downloadPath -Destination "$appDir"

Invoke-ElevatedCommand "cmd.exe" `
    -ArgumentList "/c mklink '$env:ChocolateyInstall\bin\octo.exe' '$appDir\octo.exe'" -Wait
