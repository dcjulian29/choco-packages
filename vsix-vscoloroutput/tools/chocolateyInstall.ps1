$packageName = "vsix-vscoloroutput"
$vsgallery = "https://visualstudiogallery.msdn.microsoft.com"
$vsix = "f4d9c2b5-d6d7-4543-a7a5-2d7ebabc2496/file/63103/18/VSColorOutput.vsix"
$url = "$vsgallery/$vsix"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyVsixPackage $packageName $url
