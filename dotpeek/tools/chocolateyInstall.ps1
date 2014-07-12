$packageName = "dotpeek"
$installerType = "MSI"
$installerArgs = "/qn"
$url = "http://download.jetbrains.com/dotpeek/dotPeekSetup-1.1.1.33.msi"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
