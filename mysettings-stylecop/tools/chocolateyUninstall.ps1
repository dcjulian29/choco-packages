$packageName = "mysettings-stylecop"
if (Test-Path "${$env:ProgramFiles(x86)}\StyleCop 4.7") {
    $appDir = "$({$env:ProgramFiles(x86)})\StyleCop 4.7"
}

if (Test-Path "$($env:ProgramFiles)\StyleCop 4.7") {
    $appDir = "$($env:ProgramFiles)\StyleCop 4.7"
}

if (Test-Path $appDir)
{
    Remove-Item "$($appDir)\Settings.StyleCop" -Force
}
