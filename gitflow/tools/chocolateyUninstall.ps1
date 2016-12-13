$packageName = "gitflow"

Invoke-ElevatedScript {
    if (Test-Path "$env:ProgramFiles\Git") {
        $git = "$env:ProgramFiles\Git"
    }

    if (Test-Path "${env:ProgramFiles(x86)}\Git") {
        $git = "${env:ProgramFiles(x86)}\Git"
    }

    Get-ChildItem -Path "$git" -Include 'git-flow*','gitflow-*','gitflow*' -Recurse `
        | Remove-Item -Recurse -Force
    Get-ChildItem -Path "$git" -Include 'getopt.exe','libintl3.dll','libiconv2.dll' -Recurse `
        | Remove-Item -Recurse -Force
}
