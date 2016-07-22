$packageName = "vsix-slowcheetah"
$vsgallery = "https://visualstudiogallery.msdn.microsoft.com"
$vsix = "05bb50e3-c971-4613-9379-acae2cfe6f9e/file/171400/1/SlowCheetah.vsix"
$url = "$vsgallery/$vsix"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyVsixPackage $packageName $url
