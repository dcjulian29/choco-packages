$packageName = "fiddler"
$installerType = "EXE"
$installerArgs = "/S"
$url = "http://d585tldpucybw.cloudfront.net/docs/default-source/fiddler/fiddler4setup.exe?sfvrsn=46"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url
