if (-not (Test-Path "$env:USERPROFILE\.vscode\extensions")) {
    New-Item -Type Directory -Path "$env:USERPROFILE\.vscode\extensions" | Out-Null
}

if (-not (Test-Path "$env:APPDATA\Code\User")) {
    New-Item -Type Directory -Path "$env:APPDATA\Code\User" | Out-Null
}

$code = "C:\Program Files\Microsoft VS Code\bin\code.cmd"

$packages = @(
    "bbenoist.vagrant"
    "DotJoshJohnson.xml"
    "eamodio.gitlens"
    "haaaad.ansible"
    "marcostazi.vs-code-vagrantfile"
    "mauve.terraform"
    "ms-kubernetes-tools.vscode-kubernetes-tools"
    "ms-vscode.powershell"
    "PeterJausovec.vscode-docker"
    "redhat.vscode-yaml"
    "robertohuertasm.vscode-icons"
    "rprouse.theme-obsidian"
    "shardulm94.trailing-spaces"
    "slevesque.vscode-autohotkey"
    "thomas-baumgaertner.vcl"
)

$devpackages = @(
    "cake-build.cake-vscode"
    "DavidAnson.vscode-markdownlint"
    "dbaeumer.jshint"
    "dbaeumer.vscode-eslint"
    "EditorConfig.EditorConfig"
    "idleberg.nsis"
    "jebbs.plantuml"
    "kisstkondoros.vscode-codemetrics"
    "mkaufman.htmlhint"
    "ms-mssql.mssql"
    "ms-python.python"
    "ms-vscode.csharp"
    "ms-vscode.go"
    "ms-vscode.jscs"
    "ms-vscode.vscode-typescript-tslint-plugin"
    "msjsdiag.debugger-for-chrome"
    "samverschueren.yo"
    "shinnn.stylelint"
    "sonarsource.sonarlint-vscode"
    "streetsidesoftware.code-spell-checker"
)

Write-Output "Install VS Code extensions for all installations..."

foreach ($package in $packages) {
    Start-Process -FilePath $code -ArgumentList "--install-extension $package --force" -NoNewWindow -Wait
}

if ($env:COMPUTERNAME.ToUpper().EndsWith("DEV")) {
    Write-Output "Install VS Code extensions for Development VM installations..."

    foreach ($package in $devpackages) {
        Start-Process -FilePath $code -ArgumentList "--install-extension $package --force" -NoNewWindow -Wait
    }
}

# Copy my preferred settings to the installed installation of VS Code
$settingsFile = "$env:APPDATA\Code\User\settings.json"

if (Test-Path $settingsFile) {
    Remove-Item -Path $settingsFile -Force
}

Copy-Item -Path "$PSScriptRoot\vscode.json" -Destination $settingsFile -Force #| Out-Null
