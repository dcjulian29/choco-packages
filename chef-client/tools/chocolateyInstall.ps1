$packageName = "chef-client"
$installerType = "MSI"
$installerArgs = "/quiet"
$version = "11.14.2-1"
$url = "https://opscode-omnibus-packages.s3.amazonaws.com/windows/2008r2/x86_64/chef-windows-$version.windows.msi"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    Install-ChocolateyPackage $packageName $installerType $installerArgs "" $url

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
