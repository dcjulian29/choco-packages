if (-not $(Test-Path HKCR:)) {
    New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR
}

if ($(Test-Path -LiteralPath "HKCR:\*\shell\runas")) {
    Remove-Item -LiteralPath "HKCR:\*\shell\runas" -Recurse
}
