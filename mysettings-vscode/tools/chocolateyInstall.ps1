Write-Output "Installing some VS Code extensions..."

if (-not (Test-Path "$env:USERPROFILE\.vscode\extensions")) {
    New-Item -Type Directory -Path "$env:USERPROFILE\.vscode\extensions" | Out-Null
}

if (-not (Test-Path "$env:APPDATA\Code\User")) {
    New-Item -Type Directory -Path "$env:APPDATA\Code\User" | Out-Null
}

$code = "C:\Program Files\Microsoft VS Code\bin\code.cmd"
$packages = @(
    "ms-vscode.csharp"
    "PeterJausovec.vscode-docker"
    "ms-python.python"
    "msjsdiag.debugger-for-chrome"
    "samverschueren.yo"
    "rprouse.theme-obsidian"
    "cake-build.cake-vscode"
    "DotJoshJohnson.xml"
    "EditorConfig.EditorConfig"
    "eg2.tslint"
    "haaaad.ansible"
    "kisstkondoros.vscode-codemetrics"
    "ms-vscode.powershell"
    "thomas-baumgaertner.vcl"
    "eamodio.gitlens"
    "ms-kubernetes-tools.vscode-kubernetes-tools"
    "mkaufman.htmlhint"
    "jebbs.plantuml"
    "redhat.vscode-yaml"
    "DavidAnson.vscode-markdownlint"
    "ms-vscode.go"
    "sonarsource.sonarlint-vscode"
    "idleberg.nsis"
    "marcostazi.vs-code-vagrantfile"
    "dbaeumer.vscode-eslint"
    "shardulm94.trailing-spaces"
    "mauve.terraform"
    "mkaufman.htmlhint"
    "slevesque.vscode-autohotkey"
    "robertohuertasm.vscode-icons"
    "dbaeumer.jshint"
    "shinnn.stylelint"
    "streetsidesoftware.code-spell-checker"
    "ms-vscode.jscs"
    "dbaeumer.jshint"
    "msazurermtools.azurerm-vscode-tools"
    "ms-mssql.mssql"
)

foreach ($package in $packages) {
    Start-Process -FilePath $code -ArgumentList "--install-extension $package" -NoNewWindow -Wait
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
