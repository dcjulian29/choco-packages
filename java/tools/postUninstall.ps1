$links = @(
"java"
"javaw"
"javaws"
)

foreach ($link in $links) {
    (Get-Item "${env:ChocolateyInstall}\bin\$link.exe").Delete()
}
