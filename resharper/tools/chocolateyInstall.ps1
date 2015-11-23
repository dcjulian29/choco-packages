$packageName = "resharper"
$installerType = "EXE"
$installerArgs = "/VsVersion=14 /SpecificProductNames=dotCover;teamCityAddin;ReSharper /Silent=True"
$url = "http://download.jetbrains.com/resharper/JetBrains.ReSharperUltimate.10.0.1.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url
