$packageName = "myvm-workstation"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {

    if (-not (Test-Path $env:SYSTEMDRIVE\home))
    {
        New-Item -Type Directory -Path $env:SYSTEMDRIVE\home | Out-Null
    }

    Set-Content $env:SYSTEMDRIVE\home\desktop.ini @"
[.ShellClassInfo]
IconResource=$env:WINDIR\system32\SHELL32.dll,150
[ViewState]
Mode=
Vid=
FolderType=Generic
"@
    attrib +S +H $env:SYSTEMDRIVE\home\desktop.ini
    attrib +S $env:SYSTEMDRIVE\home

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
