$packages  = @(
    "ecmel.vscode-html-css"
    "VisualStudioExptTeam.vscodeintellicode"
    "Zignd.html-css-class-completion"
    "mkaufman.HTMLHint"
    "SonarSource.sonarlint-vscode"
)

foreach ($package in $packages) {
    Start-Process -FilePath $code -ArgumentList "--install-extension $package --force" -NoNewWindow -Wait
}
