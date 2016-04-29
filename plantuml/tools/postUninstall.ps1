$links = @(
    "plantuml.bat"
)

foreach ($link in $links) {
    if (Test-Path "${env:ChocolateyInstall}\bin\$link") {
        (Get-Item "${env:ChocolateyInstall}\bin\$link").Delete()
    }
}
