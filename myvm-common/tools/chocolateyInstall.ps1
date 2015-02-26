$packageName = "myvm-common"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {

    if (-not (Test-Path $env:SYSTEMDRIVE\etc))
    {
        New-Item -Type Directory -Path $env:SYSTEMDRIVE\etc | Out-Null
    }
    
    if (-not (Test-Path $env:SYSTEMDRIVE\tools))
    {
        New-Item -Type Directory -Path $env:SYSTEMDRIVE\tools | Out-Null
        if (-not (Test-Path $env:SYSTEMDRIVE\tools\apps))
        {
            New-Item -Type Directory -Path $env:SYSTEMDRIVE\tools\apps | Out-Null
        }
    }
 
    Set-Content $env:SYSTEMDRIVE\tools\desktop.ini @"
[.ShellClassInfo]
IconResource=$env:WINDIR\system32\SHELL32.dll,218
[ViewState]
Mode=
Vid=
FolderType=Generic
"@
 
    attrib.exe +S +H $env:SYSTEMDRIVE\tools\desktop.ini
    attrib.exe +S $env:SYSTEMDRIVE\tools
    
    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
