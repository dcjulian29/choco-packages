$packageName = "powershell"
$installerType = "MSU"
$installerArgs = "/quiet /norestart"
$validExitCodes = @(0, 3010, 2359302) # 2359302 occurs if the package is already installed

$Wmf432 = "http://download.microsoft.com/download/3/D/6/3D61D262-8549-4769-A660-230B67E15B25/Windows6.1-KB2819745-x86-MultiPkg.msu"
$Wmf464 = "http://download.microsoft.com/download/3/D/6/3D61D262-8549-4769-A660-230B67E15B25/Windows6.1-KB2819745-x64-MultiPkg.msu"

$Win732 = "http://go.microsoft.com/fwlink/?LinkID=717962"
$Win72008R2 = "http://go.microsoft.com/fwlink/?LinkId=717504"

$Win832 = "http://go.microsoft.com/fwlink/?LinkID=717963"
$Win8Win2012R264 = "http://go.microsoft.com/fwlink/?LinkId=717507"

$Win2012 = "http://download.microsoft.com/download/3/D/6/3D61D262-8549-4769-A660-230B67E15B25/Windows8-RT-KB2799888-x64.msu"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

if ($PSVersionTable.psversion -ne $null) {
    $psversion = $PSVersionTable.psversion.Major
} else {
    $psversion = 0
}

if ($psversion -lt 3) {
    throw "This version of Windows isn't supported by this package."
}

if ($psversion -eq 5) {
    # Windows 10 and Windows Server 2016
    Write-Output "PowerShell Version 5 is already installed..."
} else {
    $OsMajor = [System.Environment]::OSVersion.Version.Major
    $OsMinor = [System.Environment]::OSVersion.Version.Minor
    
    if ($OsMajor -eq 6) {
        if ($OsMinor -eq 1) {
            # Windows Server 2008 R2 and Windows 7 (6.1)
            # Windows Server 2008 R2 and Windows 7 SP1 require WMF 4.0 to be installed first.
            Install-ChocolateyPackage "wmf4" $installerType $installerArgs $Wmf432 $Wmf464 -validExitCodes $validExitCodes
            Install-ChocolateyPackage $packageName $installerType $installerArgs $Win732 $Win72008R2
        }

        if ($OsMinor -eq 2) {
            # WMF 4.0 doesn't run on 8.0 and Microsoft's answer is to upgrade for free to 8.1 #FAIL
            if ((Get-CimInstance Win32_OperatingSystem | Select-Object Caption) -contains "2012") {
                # Windows Server 2012 (6.2)
                Install-ChocolateyPackage $packageName $installerType $installerArgs "" $Win2012
            }
        }

        if ($OsMinor -eq 3) {
            # Windows 8.1 and Windows Server 2012 R2 (6.3)
            Install-ChocolateyPackage $packageName $installerType $installerArgs $Win832 $Win8Win2012R264
        }
    }
}
