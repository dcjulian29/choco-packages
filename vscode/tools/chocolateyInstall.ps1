$packageName = "vscode"
$installerType = "EXE"
$installerArgs = "/SILENT /MERGETASKS=!runCode,!addtopath,addcontextmenufolders"
$url = "https://az764295.vo.msecnd.net/stable/9e4e44c19e393803e2b05fe2323cf4ed7e36880e/VSCodeSetup-stable.exe"
$downloadPath = "$env:TEMP\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.$installerType"

Invoke-ElevatedCommand "$downloadPath\$packageName.$installerType" -ArgumentList $installerArgs -Wait

if (Test-Path "$($env:PUBLIC)\Desktop\Visual Studio Code.lnk") {
    Invoke-ElvatedScript { Remove-Item "$($env:PUBLIC)\Desktop\Visual Studio Code.lnk" -Force }
}

Write-Output "Install some VS Code extensions..."

if (-not (Test-Path "$env:USERPROFILE\.vscode\extensions")) {
    New-Item -Type Directory -Path "$env:USERPROFILE\.vscode\extensions" | Out-Null
}

if (-not (Test-Path "$env:APPDATA\Code\User")) {
    New-Item -Type Directory -Path "$env:APPDATA\Code\User" | Out-Null
}

$code = "$env:PF32\Microsoft VS Code\bin\code.cmd"

Start-Process -FilePath $code -ArgumentList "--install-extension ms-vscode.csharp" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension donjayamanne.python" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension msjsdiag.debugger-for-chrome" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension samverschueren.yo" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension rprouse.theme-obsidian" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension PeterJausovec.vscode-docker" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension Pendrica.Chef" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension cake-build.cake-vscode" -NoNewWindow -Wait

