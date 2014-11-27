$packageName = "obs"
$installerType = "EXE"
$installerArgs = "/S"
$url = "https://github.com/jp9000/OBS/releases/download/0.638b/OBS_0_638b_Installer.exe"

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
