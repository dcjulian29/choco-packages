$packageName = "puppet"
$installerType = "MSI"
$installerArgs = "/quiet /passive"
$url = " http://downloads.puppetlabs.com/windows/puppet-3.7.0.msi"
$url64 = "http://downloads.puppetlabs.com/windows/puppet-3.7.0-x64.msi"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
