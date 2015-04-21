$packageName = "vsix-postsharp"
$vsgallery = "http://visualstudiogallery.msdn.microsoft.com"
$vsix = "a058d5d3-e654-43f8-a308-c3bdfdd0be4a/file/89212/55/PostSharp-4.1.11.exe"
$url = "$vsgallery/$vsix"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyVsixPackage $packageName $url
