$packages  = @(
    "ms-python.python"
    "VisualStudioExptTeam.vscodeintellicode"
    "SonarSource.sonarlint-vscode"
)

foreach ($package in $packages) {
    Start-Process -FilePath $code -ArgumentList "--install-extension $package --force" -NoNewWindow -Wait
}
