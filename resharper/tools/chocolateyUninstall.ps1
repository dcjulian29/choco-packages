$packageName = "resharper"
$installerType = "EXE"
$installerArgs = "/SpecificProductNames=ReSharper /HostsToRemove=ReSharperPlatformVs12;ReSharperPlatformVs14 /Hive=* /ReSharper9PlusMsi=True"
$url = "https://download.jetbrains.com/resharper/JetBrains.ReSharperUltimate.2015.1.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Push-Location $env:TEMP
Get-WebFile $url
Uninstall-ChocolateyPackage $packageName $installerType $installerArgs "ReSharperAndToolsPacked01Update1.exe"
Pop-Location
