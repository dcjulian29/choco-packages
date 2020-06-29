if (-not (Test-Path $env:SYSTEMDRIVE\Ubuntu)) {
    if ([System.Environment]::OSVersion.Version.Build -ge 19041) {

        $reg = "HKEY_CLASSES_ROOT\Installer\Products\9BB858F9F651C4C42959A060AC381DC7"
        if (-not (Test-Path "Microsoft.PowerShell.Core\Registry::$reg")) {
            Write-Output "Downloading WSL 2 Kernel Update..."
            Invoke-WebRequest -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" `
                -OutFile "$env:TEMP\wsl_update_x64.msi"

            Start-Process `
                "$env:TEMP\wsl_update_x64.msi" "/passive /L*V `"$env:TEMP\wslkernelupdate.log`"" `
                -Wait

            Get-Content "$env:TEMP\wslkernelupdate.log"
        }

        wsl.exe --set-default-version 2
    }

    Write-Output "Downloading and installing Ubuntu 20.04 ..."

    if (Test-Path $env:TEMP\ubuntu.appx) {
        Remove-Item -Path $env:TEMP\ubuntu.appx -Force | Out-Null
    }

    if (Test-Path $env:TEMP\ubuntu.zip) {
        Remove-Item -Path $env:TEMP\ubuntu.zip -Force | Out-Null
    }

    Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile $env:TEMP\Ubuntu.appx -UseBasicParsing

    Rename-Item $env:TEMP\Ubuntu.appx $env:TEMP\Ubuntu.zip

    New-Item -Type Directory -Path $env:SYSTEMDRIVE\Ubuntu | Out-Null

    Expand-Archive $env:TEMP\Ubuntu.zip $env:SYSTEMDRIVE\Ubuntu

    Set-Content $env:SYSTEMDRIVE\Ubuntu\desktop.ini @"
    [.ShellClassInfo]
    IconResource=$env:SYSTEMDRIVE\Ubuntu\ubuntu2004.exe,0
"@

    attrib +S +H $env:SYSTEMDRIVE\Ubuntu\desktop.ini
    attrib +S $env:SYSTEMDRIVE\Ubuntu

    Remove-Item -Path $env:TEMP\ubuntu.zip -Force | Out-Null
} else {
    Write-Output "A version of Ubuntu is already installed. Not overwriting the installed version..."
}
