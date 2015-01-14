$packageName = "git"
$installerType = "EXE"
$installerArgs = '/SILENT /COMPONENTS="!ext,!ext\cheetah,!assoc,!assoc_sh"'
$url = "https://github.com/msysgit/msysgit/releases/download/Git-1.9.5-preview20141217/Git-1.9.5-preview20141217.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
