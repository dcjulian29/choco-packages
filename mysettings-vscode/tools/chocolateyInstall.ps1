$packageName = "mysettings-vscode"

Write-Output "Installing some VS Code extensions..."

if (-not (Test-Path "$env:USERPROFILE\.vscode\extensions")) {
    New-Item -Type Directory -Path "$env:USERPROFILE\.vscode\extensions" | Out-Null
}

if (-not (Test-Path "$env:APPDATA\Code\User")) {
    New-Item -Type Directory -Path "$env:APPDATA\Code\User" | Out-Null
}

$code = "C:\Program Files\Microsoft VS Code\bin\code.cmd"

Start-Process -FilePath $code -ArgumentList "--install-extension ms-vscode.csharp" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension PeterJausovec.vscode-docker" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension ms-python.python" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension msjsdiag.debugger-for-chrome" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension samverschueren.yo" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension rprouse.theme-obsidian" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension cake-build.cake-vscode" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension DotJoshJohnson.xml" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension EditorConfig.EditorConfig" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension eg2.tslint" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension haaaad.ansible" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension kisstkondoros.vscode-codemetrics" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension ms-vscode.PowerShell" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension thomas-baumgaertner.vcl" -NoNewWindow -Wait
