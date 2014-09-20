$packageName = "vsix-xunitrunner"
$vsgallery = "http://visualstudiogallery.msdn.microsoft.com"
$vsix = "cf49cf30-2ca6-4ea0-b7cc-6a8e0dadc1a8/file/101267/10/GitDiffMargin.vsix"
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
