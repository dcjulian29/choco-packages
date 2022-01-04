$settingsFile = "$($env:APPDATA)\Notepad++\config.xml"
$packageFile = "$PSScriptRoot\config.xml"

if (Test-Path $packageFile) {
    Remove-Item -Path $packageFile -Force
}

Copy-Item -Path $settingsFile -Destination $packageFile
