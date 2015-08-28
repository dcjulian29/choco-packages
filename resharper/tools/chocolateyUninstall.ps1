$packageName = "resharper"
$installerType = "EXE"
$installerArgs = "/SpecificProductNamesToRemove=ReSharper /Silent=True /ReSharper9PlusMsi=True"
$url = "http://download.jetbrains.com/resharper/JetBrains.ReSharperUltimate.2015.2.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Push-Location $env:TEMP
Get-WebFile $url
Uninstall-ChocolateyPackage $packageName $installerType $installerArgs "JetBrains.ReSharperUltimate.2015.2.exe"
Pop-Location
