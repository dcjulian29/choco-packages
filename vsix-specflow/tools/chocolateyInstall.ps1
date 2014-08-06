$packageName = "vsix-specflow"
$vsgallery = "http://visualstudiogallery.msdn.microsoft.com"
$vsix = "90ac3587-7466-4155-b591-2cd4cc4401bc/file/112721/3/TechTalk.SpecFlow.Vs2013Integration.vsix"
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
