$packageName = "docker"
$installerType = "MSI"
$installerArgs = '/norestart /passive'
$url = "https://download.docker.com/win/stable/InstallDocker.msi"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $null $url
