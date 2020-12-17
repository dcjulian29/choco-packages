if (Test-Path "$env:ProgramFiles\Git") {
    $git = "$env:ProgramFiles\Git\bin\git.exe"
}

if (Test-Path "${env:ProgramFiles(x86)}\Git") {
    $git = "${env:ProgramFiles(x86)}\Git\bin\git.exe"
}

$config =  Import-Csv -Path "$PSScriptRoot\config.csv"

$config | ForEach-Object {
    if (-not $_.Key.StartsWith('#')) {
        $key = ($_.Key).Trim()
        $value = ($_.Value).Trim()
        Write-Output "Setting '$key' to '$value'..."
        & $git config --global --replace-all $key $value
    }
}
