$packageName = "vsix-productivitypowertools"
$vsgallery = "http://visualstudiogallery.msdn.microsoft.com"
$vsix = "34ebc6a2-2777-421d-8914-e29c1dfa7f5d/file/169971/1/ProPowerTools.vsix"
$url = "$vsgallery/$vsix"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyVsixPackage $packageName $url
