$packageName = "greenshot"
$installerArgs = "/SILENT /NORESTART"
$exePath = "$packageName\unins000.exe"

if (Test-Path "$env:ProgramFiles\$packageName") {
    Invoke-ElevatedCommand "$env:ProgramFiles\$exePath" -ArgumentList $installerArgs -Wait
}
 
if (Test-Path "${env:ProgramFiles(x86)}\$packageName") {
    Invoke-ElevatedCommand "${env:ProgramFiles(x86)}\$exePath" -ArgumentList $installerArgs -Wait
}
