$links = @(
    "python"
    "pythonw"
    "easy_install"
    "pip"
)

foreach ($link in $links) {
    if (Test-Path "${env:ChocolateyInstall}\bin\$link.exe") {
        (Get-Item "${env:ChocolateyInstall}\bin\$link.exe").Delete()
    }
}
