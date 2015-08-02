$packageName = "vim"
$appDir = "$($env:SYSTEMDRIVE)\tools\apps\$($packageName)"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"

$mklink = "cmd.exe /c mklink"

$links = @(
    "vi"
    "vim"
    "gvim"
)

foreach ($link in $links) {
    if (Test-Path "${env:ChocolateyInstall}\bin\$link.exe") {
        (Get-Item "${env:ChocolateyInstall}\bin\$link.exe").Delete()
    }

    Invoke-Expression "$mklink ${env:ChocolateyInstall}\bin\$link.exe $appDir\$link.exe"
}
