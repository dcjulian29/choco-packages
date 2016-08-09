if (Test-Path "$env:ProgramFiles\Git") {
    $git = "$env:ProgramFiles\Git"
}

if (Test-Path "${env:ProgramFiles(x86)}\Git") {
    $git = "${env:ProgramFiles(x86)}\Git"
}

$uninstaller = Join-Path $git "unins000.exe"

if (Test-ProcessAdminRights) {
    Start-ChocolateyProcessAsAdmin "cmd.exe /c `"$uninstaller`" /SILENT"
} else {
    Invoke-Expression "cmd.exe /c `"$uninstaller`" /SILENT"
}
