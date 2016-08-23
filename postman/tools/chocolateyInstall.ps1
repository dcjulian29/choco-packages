$packageName = "postman"
$installerType = "EXE"
$installerArgs = '-s'
$url = "https://dl.pstmn.io/download/latest/win?arch=32"
$url64 = "https://dl.pstmn.io/download/latest/win?arch=64"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64
