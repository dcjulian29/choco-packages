$packageName = "vsix-webessentials"
$vsgallery = "http://visualstudiogallery.msdn.microsoft.com"
$vsix = "ee6e6d8c-c837-41fb-886a-6b50ae2d06a2/file/146119/20/WebEssentials2015.vsix"
$url = "$vsgallery/$vsix"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyVsixPackage $packageName $url
