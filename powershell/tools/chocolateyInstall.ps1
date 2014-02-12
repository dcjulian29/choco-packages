$packageName = "powershell"
$installerType = "MSU"
$installerArgs = "/quiet /norestart"
$Win2008R232 = "http://download.microsoft.com/download/3/D/6/3D61D262-8549-4769-A660-230B67E15B25/Windows6.1-KB2819745-x86-MultiPkg.msu"
$Win2008R264 = "http://download.microsoft.com/download/3/D/6/3D61D262-8549-4769-A660-230B67E15B25/Windows6.1-KB2819745-x64-MultiPkg.msu"
$Win2012 = "http://download.microsoft.com/download/3/D/6/3D61D262-8549-4769-A660-230B67E15B25/Windows8-RT-KB2799888-x64.msu"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

try
{
    if ($PSVersionTable.psversion -ne $null) {
        $psversion = $PSVersionTable.psversion.Major
    } else {
        $psversion = 0
    }

    if ($psversion -lt 3) {
        throw "This version of Windows isn't supported by this package."
    }

    if ($psversion -eq 4) {
        Write-Output "PowerShell Version 4 is installed..."
    } else {
        $OsMajor = [System.Environment]::OSVersion.Version.Major
        $OsMinor = [System.Environment]::OSVersion.Version.Minor
        if ($OsMajor -eq 6) {
            if ($OsMinor -eq 1) {
                Install-ChocolateyPackage $packageName $installerType $installerArgs $Win2008R232 $Win2008R264
            }

            if ($OsMinor -eq 2) {
                # WMF 4.0 doesn't run on 8.0 and Microsoft's answer is to upgrade for free to 8.1 #FAIL
                if ((Get-CimInstance Win32_OperatingSystem | Select-Object Caption) -contains "2012") {
                    Install-ChocolateyPackage $packageName $installerType $installerArgs $Win2012
                }
            }
        }
    }

    if ($psversion -eq 3) {
        Write-Output "PowerShell Version 3 is installed and WMF 4.0 is not supported by this OS..."
    }

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
