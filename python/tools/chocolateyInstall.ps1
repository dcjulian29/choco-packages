$packageName = "python"
$installerType = "MSI"
$installerArgs = "/qb! TARGETDIR=$env:SYSTEMDRIVE\python ALLUSERS=1"
$url = "http://www.python.org/ftp/python/2.7.6/python-2.7.6.msi"
$url64 = "http://www.python.org/ftp/python/2.7.6/python-2.7.6.amd64.msi"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"
$ahkExe = "$env:ChocolateyInstall\apps\autohotkey\AutoHotkey.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64

    if (-not (Test-Path $downloadPath)) {
        mkdir $downloadPath | Out-Null
    }

    Push-Location $downloadPath

    # Install ez_setup
    Get-ChocolateyWebFile "ez_setup" "ez_setup.py" "http://peak.telecommunity.com/dist/ez_setup.py"
    cmd /c "$env:SYSTEMDRIVE\python\python.exe ez_setup.py"

    # Install pip
    Get-ChocolateyWebFile "pip" "get-pip.py" "https://raw.github.com/pypa/pip/master/contrib/get-pip.py"
    cmd /c "$env:SYSTEMDRIVE\python\python.exe get-pip.py"

    # Install Pywin32
    $pywin32 = "http://sourceforge.net/projects/pywin32/files/pywin32/Build%20218/pywin32-218.win32-py2.7.exe/download"
    $pywin64 = "http://sourceforge.net/projects/pywin32/files/pywin32/Build%20218/pywin32-218.win-amd64-py2.7.exe/download"

    Get-ChocolateyWebFile "pywin32" "pywin32.exe" $pywin32 $pywin64 

    $ahkScript = "$toolDir\install-pywin32.ahk"

    Start-ChocolateyProcessAsAdmin "$ahkExe $ahkScript"

    # Install wxPython
    $wxpython32 = "http://sourceforge.net/projects/wxpython/files/wxPython/2.9.5.0/wxPython2.9-win32-2.9.5.0-py27.exe/download"
    $wxpython64 = "http://sourceforge.net/projects/wxpython/files/wxPython/2.9.5.0/wxPython2.9-win64-2.9.5.0-py27.exe/download"

    Install-ChocolateyPackage "wxPython" "EXE" "/SP- /SILENT" $wxpython32 $wxpython64

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
