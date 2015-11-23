$packageName = "resharper"
$installerType = "EXE"
$installerArgs = "/SpecificProductNamesToRemove=ReSharper /Silent=True /ReSharper9PlusMsi=True"
$url = "http://download.jetbrains.com/resharper/JetBrains.ReSharperUltimate.10.0.1.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Push-Location $env:TEMP
Get-WebFile $url
Uninstall-ChocolateyPackage $packageName $installerType $installerArgs "JetBrains.ReSharperUltimate.10.0.1.exe"
Pop-Location
