# Copy my preferred settings from the installed installation of Windows Terminal to here.

$settingsFile = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$packageFile = "$PSScriptRoot\settings.json"

if (Test-Path $packageFile) {
    Remove-Item -Path $packageFile -Force
}

Copy-Item -Path $settingsFile -Destination $packageFile
