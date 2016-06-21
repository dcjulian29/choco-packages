$packageName = "vsix-aspnetwebtools"
$vsgallery = "http://visualstudiogallery.msdn.microsoft.com"
$vsix = "c94a02e9-f2e9-4bad-a952-a63a967e3935/file/77371/8/DotNetCore.1.0.0.RC2-VS2015Tools.Preview1.exe"
$url = "$vsgallery/$vsix"
$installerType = "EXE"
$installerArgs = "/INSTALL /PASSIVE /NORESTART"


if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url
