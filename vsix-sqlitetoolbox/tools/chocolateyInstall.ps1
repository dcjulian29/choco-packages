$packageName = "vsix-gitflow"
$vsgallery = "https://visualstudiogallery.msdn.microsoft.com"
$vsix = "0e313dfd-be80-4afb-b5e9-6e74d369f7a1/file/29445/74/SqlCeToolbox.vsix"
$url = "$vsgallery/$vsix"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyVsixPackage $packageName $url
