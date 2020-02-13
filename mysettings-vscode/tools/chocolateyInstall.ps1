if (-not (Test-Path "$env:USERPROFILE\.vscode\extensions")) {
    New-Item -Type Directory -Path "$env:USERPROFILE\.vscode\extensions" | Out-Null
}

if (-not (Test-Path "$env:APPDATA\Code\User")) {
    New-Item -Type Directory -Path "$env:APPDATA\Code\User" | Out-Null
}

$code = "C:\Program Files\Microsoft VS Code\bin\code.cmd"

$packages  = [string[]](Get-Content "$PSScriptRoot\extensions.default")
$packages += [string[]](Get-Content "$PSScriptRoot\extensions.windows")

if ($env:COMPUTERNAME.ToUpper().EndsWith("DEV")) {
    $packages += [string[]](Get-Content "$PSScriptRoot\extensions.development")
}

foreach ($package in $packages) {
    Start-Process -FilePath $code -ArgumentList "--install-extension $package --force" -NoNewWindow -Wait
}

# Copy my preferred settings to the installed installation of VS Code
$settingsFile = "$env:APPDATA\Code\User\settings.json"

if (Test-Path $settingsFile) {
    Remove-Item -Path $settingsFile -Force
}

Copy-Item -Path "$PSScriptRoot\vscode.json" -Destination $settingsFile -Force #| Out-Null
