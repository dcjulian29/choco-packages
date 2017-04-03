$packageName = "xmlquire"
$url = "http://qutoric.com/coherentweb/resources/XMLQuireWin8.zip"
$appDir = "$($env:SYSTEMDRIVE)\tools\$($packageName)"
$downloadPath = "$env:LOCALAPPDATA\Temp\$packageName"

if (-not (Test-Path $downloadPath)) {
    New-Item -Type Directory -Path $downloadPath | Out-Null
}

Download-File $url "$downloadPath\$packageName.zip"

if (Test-Path $appDir) {
    Write-Output "Removing previous version of package..."
    Remove-Item "$($appDir)" -Recurse -Force
}

New-Item -Type Directory -Path $appDir | Out-Null
    
Push-Location $downloadPath

& 7z.exe x $downloadPath\$packageName.zip

Copy-Item -Path "$downloadPath\Application Files\*\*" -Destination "$appDir" -Recurse -Container
