if (-not $(Test-Path HKCR:)) {
    New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR
}

$directory = "HKCR:\Directory\shell"
$drive = "HKCR:\Drive\shell"

if ($(Test-Path "$directory\PowerShellHere")) {
    Remove-Item -Path "$directory\PowerShellHere" -Recurse
}

New-Item -Path $directory -Name PowerShellHere
Set-Item -Path "$directory\PowerShellHere" -Value "`&PowerShell Here"
New-ItemProperty -Path "$directory\PowerShellHere" -Name icon -PropertyType String -Value "$env:WINDIR\system32\windowspowershell\v1.0\powershell.exe"

if (-not $(Test-Path "$directory\PowerShellHere\command")) {
    New-Item -Path "$directory\PowerShellHere" -Name command
}

Set-Item -Path "$directory\PowerShellHere\command" -Value `
"$env:WINDIR\system32\windowspowershell\v1.0\powershell.exe -NoExit -Command [Environment]::CurrentDirectory=(Set-Location -LiteralPath:'%L' -PassThru).ProviderPath"

if ($(Test-Path "$drive\PowerShellHere")) {
    Remove-Item -Path "$drive\PowerShellHere" -Recurse
}

New-Item -Path $drive -Name PowerShellHere
Set-Item -Path "$drive\PowerShellHere" -Value "`&PowerShell Here"
New-ItemProperty -Path "$drive\PowerShellHere" -Name icon -PropertyType String -Value "$env:WINDIR\system32\windowspowershell\v1.0\powershell.exe"

if (-not $(Test-Path "$drive\PowerShellHere\command")) {
    New-Item -Path "$drive\PowerShellHere" -Name command
}

Set-Item -Path "$drive\PowerShellHere\command" -Value `
"$env:WINDIR\system32\windowspowershell\v1.0\powershell.exe -NoExit -Command [Environment]::CurrentDirectory=(Set-Location -LiteralPath:'%L' -PassThru).ProviderPath"
