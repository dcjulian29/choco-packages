$packageName = "vsix-productivitypowertools"
$vsgallery = "http://visualstudiogallery.msdn.microsoft.com"
$vsix = "dbcb8670-889e-4a54-a226-a48a15e4cace/file/117115/4/ProPowerTools.vsix"
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
