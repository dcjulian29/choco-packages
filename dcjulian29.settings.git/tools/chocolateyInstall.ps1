$git = Find-Git
$config =  Import-Csv -Path "$PSScriptRoot\config.csv"

$config | ForEach-Object {
    if (-not $_.Key.StartsWith('#')) {
        $key = ($_.Key).Trim()
        $value = ($_.Value).Trim()
        Write-Output "Setting $key to $value..."
        & $git config --global --replace-all $key $value
    }
}

# Adding some git commands from https://github.com/tj/git-extras
# that I've found and use on Linux OS...

$gitroot = $git.Replace('\bin\git.exe', '').Replace('\cmd\git.exe', '')
$binaries = "$gitroot\usr\bin"
$manuals = "$gitroot\mingw64\share\doc\git-doc"

Copy-Item -Path $PSScriptRoot/../contents/bin/* -Destination $binaries -Force
Copy-Item -Path $PSScriptRoot/../contents/man/* -Destination $manuals -Force

$editor = "'C:/Program Files/notepad++/notepad++.exe' -multiInst -notabbar -nosession -noPlugin"

[System.Environment]::SetEnvironmentVariable('EDITOR', $editor, 'User')
