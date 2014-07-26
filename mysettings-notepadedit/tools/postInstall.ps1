if (-not $(Test-Path HKCR:)) {
    New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR
}

if ($(Test-Path -LiteralPath "HKCR:\*\shell\runas")) {
    Remove-Item -LiteralPath "HKCR:\*\shell\runas" -Recurse
}

Set-Location -LiteralPath "HKCR:\*\shell"

New-Item -Name runas
Set-Item -Path ".\runas" -Value "Open in Notepad (Admin)"
New-ItemProperty -Path ".\runas" -Name HasLUAshield -PropertyType String -Value ""
New-ItemProperty -Path ".\runas" -Name icon -PropertyType String `
    -Value "$($env:WINDIR)\system32\notepad.exe"

if (-not $(Test-Path -LiteralPath "HKCR:\*\shell\runas\command")) {
    Set-Location -LiteralPath "HKCR:\*\shell\runas"
    New-Item -Name command
}

Set-Location -LiteralPath "HKCR:\*\shell\runas\command"
Set-Item -Path "." -Value "$($env:WINDIR)\System32\notepad.exe `"%1`""
New-ItemProperty -Path "." -Name IsolatedCommand -PropertyType String `
    -Value "$($env:WINDIR)\System32\notepad.exe `"%1`""
