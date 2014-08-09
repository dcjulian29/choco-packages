$packageName = "vsix-xunitrunner"
$vsgallery = "http://visualstudiogallery.msdn.microsoft.com"
$vsix = "463c5987-f82b-46c8-a97e-b1cde42b9099/file/66837/19/xunit.runner.visualstudio.vsix"
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
