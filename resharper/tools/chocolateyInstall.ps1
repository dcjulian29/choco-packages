$packageName = "resharper"
$installerType = "EXE"
$installerArgs = "/SpecificProductNames=ReSharper /Silent=True"
$url = "http://download.jetbrains.com/resharper/JetBrains.ReSharperUltimate.10.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url
