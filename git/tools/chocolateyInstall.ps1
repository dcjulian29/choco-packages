$packageName = "git"
$installerType = "EXE"
$installerArgs = '/SILENT /COMPONENTS="!ext,!ext\cheetah,!assoc,!assoc_sh"'
$version = "2.9.2"
$url = "https://github.com/git-for-windows/git/releases/download/v$version.windows.1/Git-$version-32-bit.exe"
$url64 = "https://github.com/git-for-windows/git/releases/download/v$version.windows.1/Git-$version-64-bit.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64
