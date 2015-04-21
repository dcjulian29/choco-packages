$packageName = "vsix-codemaid"
$vsgallery = "http://visualstudiogallery.msdn.microsoft.com"
$vsix = "76293c4d-8c16-4f4a-aee6-21f83a571496/file/9356/30/CodeMaid_v0.7.6.vsix"
$url = "$vsgallery/$vsix"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyVsixPackage $packageName $url
