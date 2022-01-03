$terminal = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$starship = "$env:USERPROFILE\.config\starship.toml"

if (Test-Path $terminal) {
    Remove-Item -Path $terminal -Force
}

Copy-Item -Path "$PSScriptRoot\settings.json" -Destination $terminal -Force | Out-Null

if (Test-Path $starship) {
    Remove-Item -Path $starship -Force
}

if (-not (Test-Path $(Split-Path $starship -Leaf))) {
    New-Item -Path $(Split-Path $starship -Leaf) -ItemType Directory -Force | Out-Null
}

Copy-Item -Path "$PSScriptRoot\starship.toml" -Destination $starship -Force | Out-Null
