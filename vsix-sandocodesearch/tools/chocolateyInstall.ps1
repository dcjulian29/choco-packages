$packageName = "vsix-sandocodesearch"
$vsgallery = "http://visualstudiogallery.msdn.microsoft.com"
$vsix = "06f39a31-20ce-408c-afee-8a02b484db1c/file/77601/76/UI.vsix"
$url = "$vsgallery/$vsix"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    Install-ChocolateyVsixPackage $packageName $url

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
