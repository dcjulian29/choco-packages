$settingsFile = "$($env:APPDATA)\Notepad++\themes\MyObsidian.xml"
$packageFile = "$PSScriptRoot\MyObsidian.xml"

& 'C:\Program Files\WinMerge\WinMergeU.exe' $settingsFile $packageFile
