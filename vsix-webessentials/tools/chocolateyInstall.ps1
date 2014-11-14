$packageName = "vsix-webessentials"
#$vsgallery = "http://visualstudiogallery.msdn.microsoft.com"
#$vsix = "56633663-6799-41d7-9df7-0f2a504ca361/file/105627/37/WebEssentials2013.vsix"
#$url = "$vsgallery/$vsix"
$url = "https://github.com/madskristensen/WebEssentials2013/releases/download/v2.5/WebEssentials2013.vsix"

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
