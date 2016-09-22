if (Test-Path "$env:ProgramFiles\Git") {
    $git = "$env:ProgramFiles\Git"
}

if (Test-Path "${env:ProgramFiles(x86)}\Git") {
    $git = "${env:ProgramFiles(x86)}\Git"
}

$uninstaller = Join-Path $git "unins000.exe"

Invoke-ElevatedCommand $uninstaller "/SILENT" -Wait
