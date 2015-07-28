$packageName = "vsix-ihateregions"
$vsgallery = "http://visualstudiogallery.msdn.microsoft.com"
$vsix = "0ca60d35-1e02-43b7-bf59-ac7deb9afbca/file/69113/8/DisableRegions.vsix"
$url = "$vsgallery/$vsix"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyVsixPackage $packageName $url
