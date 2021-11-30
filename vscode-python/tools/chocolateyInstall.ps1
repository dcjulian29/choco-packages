$packages  = @(
    "ms-python.python"
    "VisualStudioExptTeam.vscodeintellicode"
    "SonarSource.sonarlint-vscode"
)

$code = "C:\Program Files\Microsoft VS Code\bin\code.cmd"

foreach ($package in $packages) {
    Start-Process -FilePath $code -ArgumentList "--install-extension $package --force" -NoNewWindow -Wait
}
