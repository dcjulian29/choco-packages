$packageName = "resharper"
$installerType = "EXE"
$installerArgs = "/VsVersion=14 /SpecificProductNames=ReSharper;dotCover;teamCityAddin;dotPeek /Silent=True"
$url = "https://download.jetbrains.com/resharper/JetBrains.ReSharperUltimate.2016.2.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url
