$appDir = "$($env:JAVA_HOME)\bin"
$mklink = "cmd.exe /c mklink"
$links = @(
"java"
"javaw"
"javaws"
)

foreach ($link in $links) {
    if (Test-Path "${env:ChocolateyInstall}\bin\$link.exe") {
        (Get-Item "${env:ChocolateyInstall}\bin\$link.exe").Delete()
    }

    Invoke-Expression "$mklink '${env:ChocolateyInstall}\bin\$link.exe' '$appDir\$link.exe'"
}
