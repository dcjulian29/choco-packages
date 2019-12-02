$etc = "$env:SystemDrive\etc\visualstudio\Code Snippets"
$snippets = "$env:USERPROFILE\Documents\Visual Studio 2019"

if (-not (Test-Path $snippets)) {
    New-Item -Path $snippets -ItemType Directory | Out-Null
}

if (Test-Path $etc) {
    Copy-Item -Path $etc -Destination $snippets -Recurse -Force
}
