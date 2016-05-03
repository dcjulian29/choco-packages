$packageName = "vsix-jslint"
$vsgallery = "https://visualstudiogallery.msdn.microsoft.com"
$vsix = "ede12aa8-0f80-4e6f-b15c-7a8b3499370e/file/111592/31/JSLintNet.VisualStudio.2.2.2.vsix"
$url = "$vsgallery/$vsix"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyVsixPackage $packageName $url
