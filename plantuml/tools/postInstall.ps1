$packageName = "plantuml"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$mklink = "cmd.exe /c mklink"
$links = @(
    "plantuml.bat"
)

foreach ($link in $links) {
    if (Test-Path "${env:ChocolateyInstall}\bin\$link") {
        (Get-Item "${env:ChocolateyInstall}\bin\$link").Delete()
    }

    Invoke-Expression "$mklink '${env:ChocolateyInstall}\bin\$link' '$appDir\$link'"
}
