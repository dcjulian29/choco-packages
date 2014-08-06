$packageName = "vsix-perfwatson"
$vsgallery = "http://visualstudiogallery.msdn.microsoft.com"
$vsix = "ad0897b3-7537-4c92-a38c-104b0e005206/file/75983/4/PerfWatsonMonitor.vsix"
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
