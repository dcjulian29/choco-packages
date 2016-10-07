$packageName = "sqlmanagementstudio"
$installerType = "EXE"
$installerArgs = "/install /quiet /norestart"
$url = "http://download.microsoft.com/download/7/8/0/7808D223-499D-4577-812B-9A2A60048841/SSMS-Setup-ENU.exe"
$downloadPath = "$($env:TEMP)\$packageName"

if (Test-Path $downloadPath)
{
    Remove-Item -Path $downloadPath -Force -Recurse
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.$installerType"

# The new installer shows no UI in command-line installs.
Write-Output "Installing Sql Server Management Studio Started..."
Invoke-ElevatedCommand "$downloadPath\$packageName.$installerType" -ArgumentList $installerArgs -Wait
Write-Output "Installing Sql Server Management Studio Finished."
