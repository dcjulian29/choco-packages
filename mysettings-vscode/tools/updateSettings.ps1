# Copy my preferred settings from the installed installation of VS Code to here.

$settingsFile = "$env:APPDATA\Code\User\settings.json"
$packageFile = "$PSScriptRoot\vscode.json"

if (Test-Path $packageFile) {
    Remove-Item -Path $packageFile -Force
}

$file = Get-Content $settingsFile -Encoding UTF8 | Out-String
$settingsContent = ConvertFrom-Json -InputObject $file

$packageContent = ConvertTo-Json $settingscontent -Depth 100

$packageContent | Set-Content $packageFile
