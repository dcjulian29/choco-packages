if (-not (Test-Path "$env:LocalAppData\FreeCommanderXE\Settings")) {
    if (-not (Test-Path "$env:LocalAppData\FreeCommanderXE")) {
        New-Item -Path "$env:LocalAppData\FreeCommanderXE" -ItemType Directory | Out-Null
    }

    New-Item -Path "$env:LocalAppData\FreeCommanderXE\Settings" -ItemType Directory | Out-Null
}

Copy-Item -Path "$PSScriptRoot\..\content\*" `
    -Destination "$env:LocalAppData\FreeCommanderXE\Settings" -Recurse -Force
