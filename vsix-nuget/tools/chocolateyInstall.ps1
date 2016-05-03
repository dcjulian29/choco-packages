$packageName = "vsix-nuget"
$vsgallery = "https://visualstudiogallery.msdn.microsoft.com"
$vsix = "5d345edc-2e2d-4a9c-b73b-d53956dc458d/file/146283/12/NuGet.Tools.vsix"
$url = "$vsgallery/$vsix"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyVsixPackage $packageName $url
