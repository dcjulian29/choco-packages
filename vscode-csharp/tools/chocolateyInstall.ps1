$packages  = @(
    "ms-dotnettools.csharp"
    "VisualStudioExptTeam.vscodeintellicode"
    "SonarSource.sonarlint-vscode"
    "pflannery.vscode-versionlens"
    "cake-build.cake-vscode"
)

foreach ($package in $packages) {
    Start-Process -FilePath $code -ArgumentList "--install-extension $package --force" -NoNewWindow -Wait
}
