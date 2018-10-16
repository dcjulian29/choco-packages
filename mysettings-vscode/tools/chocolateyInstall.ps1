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
Start-Process -FilePath $code -ArgumentList "--install-extension powershell.vscode-powershell" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension thomas-baumgaertner.vcl" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension eamodio.gitlens" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension ms-kubernetes-tools.vscode-kubernetes-tools" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension mkaufman.htmlhint" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension jebbs.plantuml" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension redhat.vscode-yaml" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension DavidAnson.vscode-markdownlint" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension ms-vscode.go" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension sonarsource.sonarlint-vscode" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension idleberg.vscode-nsis" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension marcostazi.vs-code-vagrantfile" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension dbaeumer.vscode-eslint" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension shardulm94.trailing-spaces" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension mauve.terraform" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension mkaufman.htmlhint" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension slevesque.vscode-autohotkey" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension robertohuertasm.vscode-icons" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension dbaeumer.jshint" -NoNewWindow -Wait
Start-Process -FilePath $code -ArgumentList "--install-extension shinnn.stylelint" -NoNewWindow -Wait


