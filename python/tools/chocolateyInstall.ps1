$packageName = "python"
$installerType = "MSI"
$installerArgs = "/qb! TARGETDIR=$env:SYSTEMDRIVE\python ALLUSERS=1"
$url = "https://www.python.org/ftp/python/2.7.8/python-2.7.8.msi"
$url64 = "https://www.python.org/ftp/python/2.7.8/python-2.7.8.amd64.msi"
$downloadPath = "$env:TEMP\chocolatey\$packageName"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"
$ahkExe = "$env:SYSTEMDRIVE\tools\apps\autohotkey\AutoHotkey.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64

    if (-not (Test-Path $downloadPath)) {
        New-Item -Type Directory -Path $downloadPath | Out-Null
    }

    # Install ez_setup
    $version = "0.9"
    $ezsetup = "https://pypi.python.org/packages/source/e/ez_setup/ez_setup-$version.tar.gz"

    Get-ChocolateyWebFile "ez_setup" "$downloadPath\ez_setup.tar.gz" $ezsetup
    Get-ChocolateyUnzip "$downloadPath\ez_setup.tar.gz" "$downloadPath\"
    Get-ChocolateyUnzip "$downloadPath\dist\ez_setup-$version.tar" "$downloadPath\"
    
    cmd /c "$env:SYSTEMDRIVE\python\python.exe $downloadPath\ez_setup-$version\ez_setup.py"

    # Install pip
    Get-ChocolateyWebFile "pip" "$downloadPath\get-pip.py" `
        "https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py"

    cmd /c "$env:SYSTEMDRIVE\python\python.exe $downloadPath\get-pip.py"

    # Install Pywin32
    $pywin32 = "http://sourceforge.net/projects/pywin32/files/pywin32/Build%20219/pywin32-219.win32-py2.7.exe/download"
    $pywin64 = "http://sourceforge.net/projects/pywin32/files/pywin32/Build%20219/pywin32-219.win-amd64-py2.7.exe/download"

    Get-ChocolateyWebFile "pywin32" "$downloadPath\pywin32.exe" $pywin32 $pywin64 

    $ahkScript = "$toolDir\install-pywin32.ahk"

    Start-ChocolateyProcessAsAdmin "$ahkExe $ahkScript"

    # Install wxPython
    $wxpython32 = "http://sourceforge.net/projects/wxpython/files/wxPython/3.0.0.0/wxPython3.0-win32-3.0.0.0-py27.exe/download"
    $wxpython64 = "http://sourceforge.net/projects/wxpython/files/wxPython/3.0.0.0/wxPython3.0-win64-3.0.0.0-py27.exe/download"

    Install-ChocolateyPackage "wxPython" "EXE" "/SP- /SILENT" $wxpython32 $wxpython64

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
