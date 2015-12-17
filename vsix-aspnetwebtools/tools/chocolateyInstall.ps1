$packageName = "vsix-aspnetwebtools"
$vsgallery = "http://visualstudiogallery.msdn.microsoft.com"
$vsix = "c94a02e9-f2e9-4bad-a952-a63a967e3935/file/77371/6/AspNet5.ENU.RC1_Update1.exe"
$url = "$vsgallery/$vsix"
$installerType = "EXE"
$installerArgs = "/INSTALL /PASSIVE /NORESTART"


if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url
