$settingsFile = "$($env:APPDATA)\Notepad++\themes\MyObsidian.xml"
$packageFile = "$PSScriptRoot\MyObsidian.xml"

if (Test-Path $packageFile) {
    Remove-Item -Path $packageFile -Force
}

Copy-Item -Path $settingsFile -Destination $packageFile
