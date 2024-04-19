Copy-Item -Path "$PSScriptRoot\settings.json" `
  -Destination "${env:LOCALAPPDATA}\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" `
  -Force | Out-Null
