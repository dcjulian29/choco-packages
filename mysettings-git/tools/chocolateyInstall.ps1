if (Test-Path "$env:ProgramFiles\Git") {
    $git = "$env:ProgramFiles\Git\bin\git.exe"
}

if (Test-Path "${env:ProgramFiles(x86)}\Git") {
    $git = "${env:ProgramFiles(x86)}\Git\bin\git.exe"
}

$config =  Import-Csv -Path "$PSScriptRoot\config.csv"

$config.Keys | ForEach-Object {
    if (-not $_.StartsWith('#')) {
        Write-Verbose "$_ = $($config[$_])"
        & $git config --global --replace-all $_ $config[$_]
    }
}
