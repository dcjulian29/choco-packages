$packageName = "greenshot"
$installerType = "EXE"
$installerArgs = "/SILENT"
$url = "http://downloads.sourceforge.net/project/greenshot/Greenshot/Greenshot%201.1/Greenshot-INSTALLER-1.1.7.17.exe?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fgreenshot%2Ffiles%2Flatest%2Fdownload&ts=1387226263&use_mirror=iweb"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

try
{

    if (-not (Test-Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5")) {
        # cinst netfx3 -source windowsfeatures
        # chocolatey uses the 32-bit version of DISM on a 64-bit OS which results in error...
        # until they fix, or I submit a pull request for "this" fix... I'll do the work-around here...

        $dism = "$env:WinDir\sysnative\dism.exe"
        $args = "/Online /NoRestart /Enable-Feature /FeatureName:NetFx3"
        Start-ChocolateyProcessAsAdmin "cmd /c `"$dism $param`""
    } else {
        Write-Host "Microsoft .Net 3.5 Framework is already installed on this system..."
    } 
 
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
