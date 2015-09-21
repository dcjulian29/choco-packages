$packageName = "git"
$installerType = "EXE"
$installerArgs = '/SILENT /COMPONENTS="!ext,!ext\cheetah,!assoc,!assoc_sh"'
$url = "https://github.com/git-for-windows/git/releases/download/v2.5.3.windows.1/Git-2.5.2-32-bit.exe"
$url64 = "https://github.com/git-for-windows/git/releases/download/v2.5.3.windows.1/Git-2.5.3-64-bit.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64
