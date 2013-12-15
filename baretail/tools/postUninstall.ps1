if (-not $(Test-Path HKCR:)) {
    New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR
}

Set-Location -LiteralPath HKCR:\*

if ($(Test-Path shell)) {
    if ($(Test-Path .\shell\BareTail)) {
        Remove-Item -Path .\shell\BareTail -Recurse
    }
}
