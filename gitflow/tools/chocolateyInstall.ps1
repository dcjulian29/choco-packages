$packageName = "gitflow"
$gitflow = "https://github.com/petervanderdoes/gitflow-avh/archive/1.10.2.zip"
$getoptbin = "https://julianscorner.com/downloads/util-linux-ng-2.14.1-bin.zip"
$getoptdll = "https://julianscorner.com/downloads/util-linux-ng-2.14.1-dep.zip"
$downloadPath = "$env:LOCALAPPDATA\Temp\$packageName"

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $getoptbin "$downloadPath\bin.zip"
Unzip-File "$downloadPath\bin.zip" "$downloadPath\bin\"

Download-File $getoptdll "$downloadPath\dep.zip"
Unzip-File "$downloadPath\dep.zip" "$downloadPath\dep\"

Download-File $gitflow "$downloadPath\gitflow.zip"
Unzip-File "$downloadPath\gitflow.zip" "$downloadPath\"

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

Push-Location $downloadPath

Invoke-ElevatedScript {
    if (Test-Path "$env:ProgramFiles\Git") {
        $git = "$env:ProgramFiles\Git"
    }

    if (Test-Path "${env:ProgramFiles(x86)}\Git") {
        $git = "${env:ProgramFiles(x86)}\Git"
    }

    if (Test-Path "$git\usr\bin") {
        $git = "$git\usr\bin"
    } else {
        $git = "$git\bin"
    }

    Get-ChildItem -Path . -Include 'getopt.exe','libintl3.dll','libiconv2.dll' -Recurse `
        | Copy-Item -Destination "$git" -Force
}

Invoke-ElevatedScript {
    if (Test-Path "$env:ProgramFiles\Git") {
        $git = "$env:ProgramFiles\Git"
    }

    if (Test-Path "${env:ProgramFiles(x86)}\Git") {
        $git = "${env:ProgramFiles(x86)}\Git"
    }

    if (Test-Path "$git\usr\bin") {
        $git = "$git\usr\bin"
    } else {
        $git = "$git\bin"
    }

    Get-ChildItem -Path . -Include 'git-flow*','gitflow-*','gitflow*' -Recurse `
        | Copy-Item -Destination "$git" -Force
}

Pop-Location
