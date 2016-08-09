$packageName = "tortoisegit"
$installerType = "MSI"
$installerArgs = '/quiet /qn /norestart REBOOT=ReallySuppress"'

$url = 'https://download.tortoisegit.org/tgit/2.2.0.0/TortoiseGit-2.2.0.0-32bit.msi'
$url64 = 'https://download.tortoisegit.org/tgit/2.2.0.0/TortoiseGit-2.2.0.0-64bit.msi'

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64
