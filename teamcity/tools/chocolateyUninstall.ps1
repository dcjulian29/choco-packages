$packageName = "teamcity"
$appDir = "$($env:SYSTEMDRIVE)\TeamCity"

try {
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
    
    if (Test-Path "$($env:SYSTEMDRIVE)\.BuildServer")
    {
      Remove-Item "$($env:SYSTEMDRIVE)\.BuildServer" -Recurse -Force
    }

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
