$packages  = @(
    "dbaeumer.vscode-eslint"
    "VisualStudioExptTeam.vscodeintellicode"
    "christian-kohler.npm-intellisense"
    "eg2.vscode-npm-script"
    "dbaeumer.jshint"
    "SonarSource.sonarlint-vscode"
    "pflannery.vscode-versionlens"
)

$code = "C:\Program Files\Microsoft VS Code\bin\code.cmd"

foreach ($package in $packages) {
    Start-Process -FilePath $code -ArgumentList "--install-extension $package --force" -NoNewWindow -Wait
}
