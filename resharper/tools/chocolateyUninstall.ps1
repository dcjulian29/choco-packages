$packageName = "resharper"
$installerType = "EXE"
$installerArgs = "/SpecificProductNames=ReSharper;dotCover;teamCityAddin;dotPeek /Silent=True /ReSharper9PlusMsi=True"
$url = "https://download.jetbrains.com/resharper/JetBrains.ReSharperUltimate.2016.1.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Push-Location $env:TEMP
Get-WebFile $url
Uninstall-ChocolateyPackage $packageName $installerType $installerArgs "JetBrains.ReSharperUltimate.2016.1.exe"
Pop-Location
