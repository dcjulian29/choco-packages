$links = @(
"vi"
"vim"
"gvim"
)

foreach ($link in $links) {
    (Get-Item "${env:ChocolateyInstall}\bin\$link.exe").Delete()
}
