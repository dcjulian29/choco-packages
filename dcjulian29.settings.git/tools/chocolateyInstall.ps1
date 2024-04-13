Write-Output "Adding some Git commands from https://github.com/tj/git-extras...`n"

Push-Location $env:TEMP

git clone https://github.com/tj/git-extras.git

Push-Location git-extras

cmd.exe /C install.cmd

Pop-Location
Pop-Location

Write-Output "Setting default editor for Git...`n"

$editor = "'$($env:PROGRAMFILES.Replace("\", "/"))/notepad++/notepad++.exe' -multiInst -notabbar -nosession -noPlugin"

[System.Environment]::SetEnvironmentVariable('EDITOR', $editor, 'User')
