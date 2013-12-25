$packageName = "handbrake"
$installerType = "EXE"
$installerArgs = "/S"
$url = "http://handbrake.fr/rotation.php?file=HandBrake-0.9.9-1_i686-Win_GUI.exe"
$url64 = "http://handbrake.fr/rotation.php?file=HandBrake-0.9.9-1_x86_64-Win_GUI.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
