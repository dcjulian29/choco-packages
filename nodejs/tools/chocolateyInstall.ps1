$packageName = "nodejs"
$installerType = "MSI"
$installerArgs = "/qb"
$url = "http://nodejs.org/dist/v0.10.29/node-v0.10.29-x86.msi"
$url64 = "http://nodejs.org/dist/v0.10.29/x64/node-v0.10.29-x64.msi"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
