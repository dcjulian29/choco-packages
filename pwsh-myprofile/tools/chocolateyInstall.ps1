$docDir = Join-Path -Path $env:UserProfile -ChildPath Documents
$poshDir = Join-Path -Path $docDir -ChildPath WindowsPowerShell
$pwshDir = Join-Path -Path $docDir -ChildPath PowerShell

if (-not (Test-Path $pwshDir)) {
    New-Item -ItemType SymbolicLink -Path $docDir -Name PowerShell -Target $poshDir
}
