$packageName = "sqlmanagementstudio"
$installerType = "EXE"
$installerArgs = "/install /quiet /norestart"
$url = "https://download.microsoft.com/download/3/1/D/31D734E0-BFE8-4C33-A9DE-2392808ADEE6/SSMS-Setup-ENU.exe"
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
