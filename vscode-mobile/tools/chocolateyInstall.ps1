$packages  = @(
    "msjsdiag.vscode-react-native"
)

foreach ($package in $packages) {
    Start-Process -FilePath $code -ArgumentList "--install-extension $package --force" -NoNewWindow -Wait
}
