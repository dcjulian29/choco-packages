$packageName = "vsix-stylecop"
$vsgallery = "https://visualstudiogallery.msdn.microsoft.com"
$vsix = "cac2a05b-6eb6-4fa2-95b9-1f8d011e6cae/file/173746/14/VSIXPackage.vsix"
$url = "$vsgallery/$vsix"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyVsixPackage $packageName $url
