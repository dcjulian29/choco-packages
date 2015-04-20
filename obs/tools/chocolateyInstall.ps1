$packageName = "obs"
$installerType = "EXE"
$installerArgs = "/S"
$url = "https://github.com/jp9000/OBS/releases/download/0.651b/OBS_0_651b_Installer.exe"

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
