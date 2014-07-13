$packageName = "python"
$toolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Path)"
$ahkExe = "$env:SYSTEMDRIVE\tools\apps\autohotkey\AutoHotkey.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    # Unistall wxPython
    $u = Get-ChildItem -Path "$env:SYSTEMDRIVE\python\Lib\site-packages\wx-*" -recurse -Filter "unins000.exe"
    cmd /c "$($u.FullName) /SILENT"

    # Uninstall pywin32
    $ahkScript = "$toolDir\uninstall-pywin32.ahk"
    Start-ChocolateyProcessAsAdmin "$ahkExe $ahkScript"

    # Uninstall python
    if (Test-Path "$env:WINDIR\sysnative\WindowsPowerShell\v1.0\powershell.exe") {
        $pshell = "$env:WINDIR\sysnative\WindowsPowerShell\v1.0\powershell.exe"
    } else {
        $pshell = "$env:WINDIR\system32\WindowsPowerShell\v1.0\powershell.exe"
    }

    $shellScript = "`$key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';`$packages = Get-ChildItem `$key | ForEach-Object { Get-ItemProperty `$_.pspath } | Select-Object DisplayName,PSChildName;for (`$i = 0; `$i -lt `$packages.Length; `$i++) { if (`$packages[`$i].DisplayName.Length -gt 0) { if (`$packages[`$i].DisplayName.StartsWith('Python') -and `$packages[`$i].PSChildName.StartsWith('{')) { Write-Output `$packages[`$i].PSChildName } } }"
    $packageId = cmd /c $pshell -command "$shellScript"

    cmd /c "$env:WINDIR\system32\msiexec.exe /qb /x $packageId"

    Remove-item "$env:SYSTEMDRIVE\python" -Recurse -Force
    
    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
