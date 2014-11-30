$packageName = "handbrake"
$installerType = "EXE"
$installerArgs = "/S"
$url = "https://handbrake.fr/rotation.php?file=HandBrake-0.10.0-i686-Win_GUI.exe"
$url64 = "https://handbrake.fr/rotation.php?file=HandBrake-0.10.0-x86_64-Win_GUI.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
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
