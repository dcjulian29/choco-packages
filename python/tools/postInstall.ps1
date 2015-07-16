$mklink = "cmd.exe /c mklink"
$links = @(
    "python"
    "pythonw"
)

$scripts = @(
    "easy_install"
    "pip"
)

foreach ($link in $links) {
    if (Test-Path "${env:ChocolateyInstall}\bin\$link.exe") {
        (Get-Item "${env:ChocolateyInstall}\bin\$link.exe").Delete()
    }

    Invoke-Expression "$mklink '${env:ChocolateyInstall}\bin\$link.exe' '$env:SYSTEMDRIVE\python\$link.exe'"
}

foreach ($link in $scripts) {
    if (Test-Path "${env:ChocolateyInstall}\bin\$link.exe") {
        (Get-Item "${env:ChocolateyInstall}\bin\$link.exe").Delete()
    }

    Invoke-Expression "$mklink '${env:ChocolateyInstall}\bin\$link.exe' '$env:SYSTEMDRIVE\python\scripts\$link.exe'"
}
