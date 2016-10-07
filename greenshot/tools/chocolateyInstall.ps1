$packageName = "greenshot"
$installerArgs = "/SILENT /NORESTART"
$url = "https://github.com/greenshot/greenshot/releases/download/Greenshot-RELEASE-1.2.8.12/Greenshot-INSTALLER-1.2.8.12-RELEASE.exe"
$downloadPath = "$env:TEMP\$packageName"

if (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5")) {
    $dism = "$env:WinDir\system32\dism.exe"
    $arguments = "/Online /NoRestart /Enable-Feature /FeatureName:NetFx3"

    Write-Output "Installing .Net 3.5 Framework..."

    Invoke-ElevatedCommand $dism -ArgumentList $arguments -Wait
} 

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.exe"

if (Get-Process $packageName -ErrorAction SilentlyContinue) {
    Stop-Process -ProcessName $packageName -Force -ErrorAction Stop
}

Invoke-ElevatedCommand "$downloadPath\$packageName.exe" -ArgumentList $installerArgs -Wait
