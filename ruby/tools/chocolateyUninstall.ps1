$packageName = "ruby"

Remove-item "$env:SYSTEMDRIVE\ruby" -Recurse -Force

Invoke-ElevatedScript {
    $links = @(
        "ruby"
        "gem"
        "bundle"
    )

    foreach ($link in $links) {
        if (Test-Path "${env:ChocolateyInstall}\bin\$link.exe") {
            (Get-Item "${env:ChocolateyInstall}\bin\$link.exe").Delete()
        }
    }
}
