$settingsFile = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$packageFile = "$PSScriptRoot\settings.json"

& 'C:\Program Files\WinMerge\WinMergeU.exe' $settingsFile $packageFile
