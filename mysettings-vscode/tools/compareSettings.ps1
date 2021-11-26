$settingsFile = "$env:APPDATA\Code\User\settings.json"
$packageFile = "$PSScriptRoot\vscode.json"

& 'C:\Program Files\WinMerge\WinMergeU.exe' $settingsFile $packageFile
