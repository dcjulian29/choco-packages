$packageName = "vsix-jslint"
$vsgallery = "http://visualstudiogallery.msdn.microsoft.com"
$vsix = "ede12aa8-0f80-4e6f-b15c-7a8b3499370e/file/111592/16/JSLintNet.VisualStudio.1.6.5.vsix"
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
