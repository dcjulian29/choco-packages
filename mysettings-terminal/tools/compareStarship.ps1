$settingsFile = "$env:USERPROFILE\.config\starship.toml"
$packageFile = "$PSScriptRoot\starship.toml"

& 'C:\Program Files\WinMerge\WinMergeU.exe' $settingsFile $packageFile
