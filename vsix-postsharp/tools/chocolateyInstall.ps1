$packageName = "vsix-postsharp"
$vsgallery = "http://visualstudiogallery.msdn.microsoft.com"
$vsix = "a058d5d3-e654-43f8-a308-c3bdfdd0be4a/file/89212/52/PostSharp-4.0.41.vsix"
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
