$packageName = "resharper"
$installerType = "EXE"
$installerArgs = "/SpecificProductNames=ReSharper /HostsToRemove=ReSharperPlatformVs12;ReSharperPlatformVs14 /Hive=* /ReSharper9PlusMsi=True"
$url = "http://download.jetbrains.com/resharper/ReSharperAndToolsPacked01Update1.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    Push-Location $env:TEMP
    Get-WebFile $url
    Uninstall-ChocolateyPackage $packageName $installerType $installerArgs "ReSharperAndToolsPacked01Update1.exe"
    Pop-Location

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
