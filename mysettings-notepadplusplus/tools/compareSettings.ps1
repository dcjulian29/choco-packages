$settingsFile = "$($env:APPDATA)\Notepad++\config.xml"
$packageFile = "$PSScriptRoot\config.xml"

& 'C:\Program Files\WinMerge\WinMergeU.exe' $settingsFile $packageFile
