$packageName = "nodejs"
$installerType = "MSI"
$installerArgs = "/qb"
$version = "0.10.33"
$url = "http://nodejs.org/dist/v$version/node-v$version-x86.msi"
$url64 = "http://nodejs.org/dist/v$version/x64/node-v$version-x64.msi"

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
