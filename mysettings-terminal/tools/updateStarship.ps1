# Copy my preferred settings from the installed installation of Windows Terminal to here.

$settingsFile = "$env:USERPROFILE\.config\starship.toml"
$packageFile = "$PSScriptRoot\starship.toml"

if (Test-Path $packageFile) {
    Remove-Item -Path $packageFile -Force
}

Copy-Item -Path $settingsFile -Destination $packageFile
