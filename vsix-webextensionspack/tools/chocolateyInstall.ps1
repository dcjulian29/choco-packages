$packageName = "vsix-webextensionpack"
$vsgallery = "https://visualstudiogallery.msdn.microsoft.com"
$vsix = "f3b504c6-0095-42f1-a989-51d5fc2a8459/file/186606/17/Web%20Extension%20Pack%20v1.3.40.vsix"
$url = "$vsgallery/$vsix"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyVsixPackage $packageName $url
