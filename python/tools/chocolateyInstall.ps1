$packageName = "python"
$installerType = "MSI"
$installerArgs = "/qb! TARGETDIR=$env:SYSTEMDRIVE\python ALLUSERS=1"
$url = "https://www.python.org/ftp/python/2.7.12/python-2.7.12.msi"
$url64 = "https://www.python.org/ftp/python/2.7.12/python-2.7.12.amd64.msi"
$downloadPath = "$env:TEMP\$packageName"
$ahkExe = "$env:ChocolateyInstall\bin\ahk.exe"

$downloadPath = "$env:TEMP\$packageName"

if ([System.IntPtr]::Size -ne 4) {
    $url = $url64
}

if (Test-Path $downloadPath) {
    Remove-Item -Path $downloadPath -Recurse -Force
}

New-Item -Type Directory -Path $downloadPath | Out-Null

Download-File $url "$downloadPath\$packageName.$installerType"

Invoke-ElevatedCommand "$downloadPath\$packageName.$installerType" -ArgumentList $installerArgs -Wait

Push-Location $downloadPath

# Install ez_setup
$version = "0.9"
$ezsetup = "https://pypi.python.org/packages/source/e/ez_setup/ez_setup-$version.tar.gz"

Download-File $ezsetup "$downloadPath\ez_setup.tar.gz"
& 'C:\Program Files\7-Zip\7z.exe' e "$downloadPath\ez_setup.tar.gz"
& 'C:\Program Files\7-Zip\7z.exe' x "$downloadPath\ez_setup-$version.tar"
    
cmd /c "$env:SYSTEMDRIVE\python\python.exe $downloadPath\ez_setup-$version\ez_setup.py"

# Install pip
Download-File "https://bootstrap.pypa.io/get-pip.py" "$downloadPath\get-pip.py"

cmd /c "$env:SYSTEMDRIVE\python\python.exe $downloadPath\get-pip.py"

# Install Pywin32
$pywin = "https://julianscorner.com/downloads/pywin32-220.win32-py2.7.exe"
$pywin64 = "https://julianscorner.com/downloads/pywin32-220.win-amd64-py2.7.exe"

if ([System.IntPtr]::Size -ne 4) {
    $pywin = $pywin64
}

Download-File $pywin "$downloadPath\pywin32.exe"

$ahkScript = "$PSScriptRoot\install-pywin32.ahk"

Invoke-ElevatedCommand -File $ahkExe -ArgumentList $ahkScript -Wait

# Uninstall any previous versions already installed.
if (Test-Path "C:\python\Lib\site-packages\wx-3.0-msw\unins001.exe") {
    & "C:\python\Lib\site-packages\wx-3.0-msw\unins001.exe" /SILENT
}
    
# Install wxPython
$wxpython = "https://julianscorner.com/downloads/wxPython3.0-win32-3.0.2.0-py27.exe"
$wxpython64 = "https://julianscorner.com/downloads/wxPython3.0-win64-3.0.2.0-py27.exe"

if ([System.IntPtr]::Size -ne 4) {
    $wxpython = $wxpython64
}

Download-File $wxpython "$downloadPath\wxPython.exe"

Invoke-ElevatedCommand "$downloadPath\wxPython.exe" -ArgumentList "/SP- /SILENT" -Wait

Pop-Location

Invoke-ElevatedScript {
    $mklink = "cmd.exe /c mklink"
    $links = @(
        "python"
        "pythonw"
    )

    $scripts = @(
        "easy_install"
        "pip"
    )

    foreach ($link in $links) {
        if (Test-Path "${env:ChocolateyInstall}\bin\$link.exe") {
            (Get-Item "${env:ChocolateyInstall}\bin\$link.exe").Delete()
        }

        Invoke-Expression "$mklink '${env:ChocolateyInstall}\bin\$link.exe' '$env:SYSTEMDRIVE\python\$link.exe'"
    }

    foreach ($link in $scripts) {
        if (Test-Path "${env:ChocolateyInstall}\bin\$link.exe") {
            (Get-Item "${env:ChocolateyInstall}\bin\$link.exe").Delete()
        }

        Invoke-Expression "$mklink '${env:ChocolateyInstall}\bin\$link.exe' '$env:SYSTEMDRIVE\python\scripts\$link.exe'"
    }
}
