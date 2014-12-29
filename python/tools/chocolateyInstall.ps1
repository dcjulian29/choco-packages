$packageName = "python"
$installerType = "MSI"
$installerArgs = "/qb! TARGETDIR=$env:SYSTEMDRIVE\python ALLUSERS=1"
$url = "https://www.python.org/ftp/python/2.7.9/python-2.7.9.msi"
$url64 = "https://www.python.org/ftp/python/2.7.9/python-2.7.9.amd64.msi"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"
$ahkExe = "$env:SYSTEMDRIVE\tools\apps\autohotkey\AutoHotkey.exe"
$shimgen = "$env:ChocolateyInstall\chocolateyinstall\tools\shimgen.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64

    & $shimgen -o "$env:ChocolateyInstall\bin\python.exe" -p "$env:SYSTEMDRIVE\python\python.exe"
    & $shimgen -o "$env:ChocolateyInstall\bin\pythonw.exe" -p "$env:SYSTEMDRIVE\python\pythonw.exe"

    if (-not (Test-Path $downloadPath)) {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    Push-Location $downloadPath

    # Install ez_setup
    $version = "0.9"
    $ezsetup = "https://pypi.python.org/packages/source/e/ez_setup/ez_setup-$version.tar.gz"

    Get-ChocolateyWebFile "ez_setup" "$downloadPath\ez_setup.tar.gz" $ezsetup
    Get-ChocolateyUnzip "$downloadPath\ez_setup.tar.gz" "$downloadPath\"
    Get-ChocolateyUnzip "$downloadPath\dist\ez_setup-$version.tar" "$downloadPath\"
    
    cmd /c "$env:SYSTEMDRIVE\python\python.exe $downloadPath\ez_setup-$version\ez_setup.py"

    & $shimgen -o "$env:ChocolateyInstall\bin\easy_install.exe" -p "$env:SYSTEMDRIVE\python\scripts\easy_install.exe"

    # Install pip
    Get-ChocolateyWebFile "pip" "$downloadPath\get-pip.py" `
        "https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py"

    cmd /c "$env:SYSTEMDRIVE\python\python.exe $downloadPath\get-pip.py"

    & $shimgen -o "$env:ChocolateyInstall\bin\pip.exe" -p "$env:SYSTEMDRIVE\python\scripts\pip.exe"

    # Install Pywin32
    $pywin32 = "http://sourceforge.net/projects/pywin32/files/pywin32/Build%20219/pywin32-219.win32-py2.7.exe/download"
    $pywin64 = "http://sourceforge.net/projects/pywin32/files/pywin32/Build%20219/pywin32-219.win-amd64-py2.7.exe/download"

    Get-ChocolateyWebFile "pywin32" "$downloadPath\pywin32.exe" $pywin32 $pywin64 

    $ahkScript = "$toolDir\install-pywin32.ahk"

    if (Test-ProcessAdminRights) {
        & "$ahkExe" $ahkScript
    } else {
        Start-ChocolateyProcessAsAdmin "$ahkExe $ahkScript"
    }

    # Uninstall any previous versions already installed.
    if (Test-Path "C:\python\Lib\site-packages\wx-3.0-msw\unins001.exe") {
        & "C:\python\Lib\site-packages\wx-3.0-msw\unins001.exe" /SILENT
    }
    
    # Install wxPython
    $wxpython32 = "http://sourceforge.net/projects/wxpython/files/wxPython/3.0.2.0/wxPython3.0-win32-3.0.2.0-py27.exe/download"
    $wxpython64 = "http://sourceforge.net/projects/wxpython/files/wxPython/3.0.2.0/wxPython3.0-win64-3.0.2.0-py27.exe/download"

    Install-ChocolateyPackage "wxPython" "EXE" "/SP- /SILENT" $wxpython32 $wxpython64

    Pop-Location

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
