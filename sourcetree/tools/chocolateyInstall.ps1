$packageName = "sourcetree"
$installerType = "EXE"
$installerArgs = "/passive"
$url = "https://downloads.atlassian.com/software/sourcetree/windows/SourceTreeSetup_1.8.2.11.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url
