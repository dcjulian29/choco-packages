$appExe = "$($env:SYSTEMDRIVE)\tools\apps\baretail\baretail.exe"

if (-not $(Test-Path HKCR:)) {
    New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR
}

Set-Location -LiteralPath HKCR:\*

if (-not $(Test-Path shell)) {
    New-Item -Path . -Name shell
}

if ($(Test-Path shell)) {
    if ($(Test-Path .\shell\BareTail)) {
        Remove-Item -Path .\shell\BareTail -Recurse
    }
}

New-Item -Path .\shell -Name BareTail
Set-Item -Path .\shell\BareTail -Value "View with &BareTail"
New-ItemProperty -Path .\shell\BareTail -Name icon -PropertyType String -Value "$appExe"

if (-not $(Test-Path .\shell\BareTail\command)) {
    New-Item -Path .\shell\BareTail -Name command
}

Set-Item -Path .\shell\BareTail\command -Value "$appExe `"%1`""
