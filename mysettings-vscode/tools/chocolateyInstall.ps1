Write-Output "Installing some VS Code extensions..."

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
    "eg2.tslint"
    "idleberg.nsis"
    "jebbs.plantuml"
    "kisstkondoros.vscode-codemetrics"
    "mkaufman.htmlhint"
    "ms-mssql.mssql"
    "ms-python.python"
    "ms-vscode.csharp"
    "ms-vscode.go"
    "ms-vscode.jscs"
    "msjsdiag.debugger-for-chrome"
    "samverschueren.yo"
    "shinnn.stylelint"
    "sonarsource.sonarlint-vscode"
    "streetsidesoftware.code-spell-checker"
)

Write-Information "Install VS Code extensions for all installations..."

foreach ($package in $packages) {
    Start-Process -FilePath $code -ArgumentList "--install-extension $package --force" -NoNewWindow -Wait
}

if ($env:COMPUTERNAME.ToUpper().EndsWith("DEV")) {
    Write-Information "Install VS Code extensions for Development VM installations..."

    foreach ($package in $devpackages) {
        Start-Process -FilePath $code -ArgumentList "--install-extension $package --force" -NoNewWindow -Wait
    }
}

# Disable Auto Update
$settingsFile = "$env:APPDATA\Code\User\settings.json"

if (-not (Test-Path $settingsFile)) {
    New-Item -ItemType File -Path $settingsFile | Out-Null

    $content = ConvertTo-Json @{
        "update.channel" = "none"
    }
} else {
    $content = ConvertFrom-Json -InputObject $(Get-Content $settingsFile -Encoding UTF8)

    try {
      $content."update.channel" = "none"
    } catch {
      $content | Add-Member -Name "update.channel" -value "none" -MemberType NoteProperty
    }

    $content = ConvertTo-Json $content -Depth 100
}

$content | Set-Content $settingsFile
