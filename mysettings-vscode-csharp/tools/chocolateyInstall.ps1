$packages  = [string[]](Get-Content "$PSScriptRoot\extensions.default")
$code = "C:\Program Files\Microsoft VS Code\bin\code.cmd"

foreach ($package in $packages) {
    Start-Process -FilePath $code -ArgumentList "--install-extension $package --force" -NoNewWindow -Wait
}
