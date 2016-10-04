$packageName = "octopusdeploy"
$downloadPath = "$env:TEMP\$packageName"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"

$url = "https://download.octopusdeploy.com/octopus-tools/3.4.2/OctopusTools.3.4.2.zip"

$keep = @(
  "octo.exe",
  "octo.exe.config"
)

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

Get-ChildItem -Path $downloadPath -Include $keep -Recurse | Copy-Item -Destination "$appDir"

if (Test-Elevation) {
    cmd /c mklink "$env:ChocolateyInstall\bin\octo.exe" "$appDir\octo.exe"
} else {
    Invoke-ElevatedCommand "cmd.exe" -ArgumentList "/c mklink '$env:ChocolateyInstall\bin\octo.exe' '$appDir\octo.exe'" -Wait
}
