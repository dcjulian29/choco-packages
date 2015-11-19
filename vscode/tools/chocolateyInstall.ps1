$packageName = "vscode"
$installerType = "EXE"
$installerArgs = "/SILENT /NORESTART"
$url = "https://az764295.vo.msecnd.net/public/0.10.1-release/VSCodeSetup.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url
