$packageName = "resharper"
$installerType = "EXE"
$installerArgs = "/SpecificProductNames=ReSharper /Silent=True"
$url = "https://download.jetbrains.com/resharper/JetBrains.ReSharperUltimate.2015.1.1.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url
