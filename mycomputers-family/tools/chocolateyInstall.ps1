$packageName = "mycomputers-family"

if (Test-Path $env:SYSTEMDRIVE\home)
{
    Remove-Item -Path $env:SYSTEMDRIVE\home
}

if (Test-Path $env:SYSTEMDRIVE\tools)
{
    Remove-Item -Path $env:SYSTEMDRIVE\tools
}

Enable-PSRemoting -Force
