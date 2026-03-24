$folder = "${env:LOCALAPPDATA}\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

if (-not (Test-Path -Path $folder)) {
  New-Item -Name $folder -ItemType Directory | Out-Null
}

Copy-Item -Path "$PSScriptRoot\settings.json" -Destination "$foldwe\settings.json" `
  -Force | Out-Null
