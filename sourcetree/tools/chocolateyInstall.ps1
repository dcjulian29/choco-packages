$packageName = "sourcetree"
$installerType = "EXE"
$installerArgs = "/passive"
$url = "http://downloads.atlassian.com/software/sourcetree/windows/SourceTreeSetup_1.7.0.32509.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url
