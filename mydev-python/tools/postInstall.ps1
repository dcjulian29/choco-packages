$mklink = "cmd.exe /c mklink"
$links = @(
"pylint"
"pep8"
)

foreach ($link in $links) {
    if (Test-Path "${env:ChocolateyInstall}\bin\$link.exe") {
        (Get-Item "${env:ChocolateyInstall}\bin\$link.exe").Delete()
    }

    Invoke-Expression "$mklink '${env:ChocolateyInstall}\bin\$link.exe' '$env:SYSTEMDRIVE\python\scripts\$link.exe'"
}
