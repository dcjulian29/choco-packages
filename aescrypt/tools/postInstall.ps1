$packageName = "aescrypt"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$mklink = "cmd.exe /c mklink"
$links = @(
    "aescrypt.exe"
)

foreach ($link in $links) {
    if (Test-Path "${env:ChocolateyInstall}\bin\$link") {
        (Get-Item "${env:ChocolateyInstall}\bin\$link").Delete()
    }

    Invoke-Expression "$mklink '${env:ChocolateyInstall}\bin\$link' '$appDir\$link'"
}
