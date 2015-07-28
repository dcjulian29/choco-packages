$packageName = "vsix-specflow"
$vsgallery = "http://visualstudiogallery.msdn.microsoft.com"
$vsix = "c74211e7-cb6e-4dfa-855d-df0ad4a37dd6/file/160542/7/TechTalk.SpecFlow.Vs2015Integration.v2015.1.2.vsix"
$url = "$vsgallery/$vsix"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyVsixPackage $packageName $url
