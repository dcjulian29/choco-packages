$packageName = "vsix-gitflow"
$vsgallery = "http://visualstudiogallery.msdn.microsoft.com"
$vsix = "27f6d087-9b6f-46b0-b236-d72907b54683/file/154064/5/GitFlowVS.2013.vsix"
$url = "$vsgallery/$vsix"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyVsixPackage $packageName $url
