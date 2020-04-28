if (-not (Test-Path $env:SYSTEMDRIVE\Ubuntu)) {
    Write-Output "Downloading and installing Ubuntu 18.04 ..."

    if (Test-Path $env:TEMP\ubuntu.appx) {
        Remove-Item -Path $env:TEMP\ubuntu.appx -Force | Out-Null
    }

    if (Test-Path $env:TEMP\ubuntu.zip) {
        Remove-Item -Path $env:TEMP\ubuntu.zip -Force | Out-Null
    }

    Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile $env:TEMP\Ubuntu.appx -UseBasicParsing

    Rename-Item $env:TEMP\Ubuntu.appx $env:TEMP\Ubuntu.zip

    New-Item -Type Directory -Path $env:SYSTEMDRIVE\Ubuntu | Out-Null

    Expand-Archive $env:TEMP\Ubuntu.zip $env:SYSTEMDRIVE\Ubuntu

    Set-Content $env:SYSTEMDRIVE\Ubuntu\desktop.ini @"
    [.ShellClassInfo]
    IconResource=$env:SYSTEMDRIVE\Ubuntu\ubuntu1804.exe,0
"@

    attrib +S +H $env:SYSTEMDRIVE\Ubuntu\desktop.ini
    attrib +S $env:SYSTEMDRIVE\Ubuntu

    Remove-Item -Path $env:TEMP\ubuntu.zip -Force | Out-Null
} else {
    Write-Output "A version of Ubunutu is already installed. Not overwriting the installed version..."
}
