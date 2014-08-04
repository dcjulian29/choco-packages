$packageName = "vlc"
$installerType = "exe"
$installerArgs = "/L=1033 /S"
$url = "http://get.videolan.org/vlc/2.1.5/win32/vlc-2.1.5-win32.exe"

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
