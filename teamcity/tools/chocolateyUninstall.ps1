$packageName = "teamcity"
$appDir = "$($env:SYSTEMDRIVE)\TeamCity"

net stop TCBuildAgent

Push-Location $appdir\buildAgent\bin
& ./service.uninstall.bat
Pop-Location

net stop TeamCity

& $appdir\bin\teamcity-server.bat service delete

if (Test-Path $appDir)
{
  Remove-Item "$($appDir)" -Recurse -Force
}
