if (Test-Path $env:SYSTEMDRIVE\etc\Sourcetree\accounts.json) {
    if (-not (Test-Path $env:LOCALAPPDATA\Atlassian\SourceTree)) {
        New-Item $env:LOCALAPPDATA\Atlassian -ItemType Directory | Out-Null
        New-Item $env:LOCALAPPDATA\Atlassian\SourceTree -ItemType Directory | Out-Null
    }

    if (-not (Test-Path "$env:LOCALAPPDATA\Atlassian\SourceTree\accounts.json")) {
        Copy-Item $env:SYSTEMDRIVE\etc\Sourcetree\accounts.json `
            $env:LOCALAPPDATA\Atlassian\SourceTree\accounts.json | Out-Null

        Copy-Item $env:SYSTEMDRIVE\etc\Sourcetree\bookmarks.xml `
            $env:LOCALAPPDATA\Atlassian\SourceTree\bookmarks.xml | Out-Null
    }
}
