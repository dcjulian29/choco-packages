$appdata = "${env:APPDATA}\Notepad++"

if (-not (Test-Path $appdata)) {
  New-Item -Type Directory -Path $appdata | Out-Null
}

Copy-Item -Path "$PSScriptRoot\config.xml" -Destination "$appdata\config.xml" -Force

if (-not (Test-Path "$appdata\themes")) {
  New-Item -Type Directory -Path "$appdata\themes" | Out-Null
}

Copy-Item -Path "$PSScriptRoot\MyObsidian.xml" -Destination "$appdata\themes\MyObsidian.xml" -Force
