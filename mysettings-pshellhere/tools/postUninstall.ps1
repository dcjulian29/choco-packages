if (-not $(Test-Path HKCR:)) {
    New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR
}

$directory = "HKCR:\Directory\shell\PowerShellHere"
$drive = "HKCR:\Drive\shell\PowerShellHere"

if ($(Test-Path $directory)) {
    Remove-Item -Path $directory -Recurse
}

if ($(Test-Path $drive)) {
    Remove-Item -Path $drive -Recurse
}
