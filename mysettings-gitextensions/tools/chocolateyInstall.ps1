if (-not (Test-Path "$env:AppData\GitExtensions\GitExtensions")) {
    if (-not (Test-Path "$env:AppData\GitExtensions")) {
        New-Item -Path "$env:AppData\GitExtensions" -ItemType Directory | Out-Null
    }

    New-Item -Path "$env:AppData\GitExtensions\GitExtensions" -ItemType Directory | Out-Null
}

Copy-Item -Path "$PSScriptRoot\..\content\*" `
    -Destination "$env:AppData\GitExtensions\GitExtensions" -Recurse -Force
