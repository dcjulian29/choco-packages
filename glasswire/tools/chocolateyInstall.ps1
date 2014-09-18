$packageName = "glasswire"
$installerType = "EXE"
$installerArgs = "/quiet"
$url = "https://www.glasswire.com/download/GlassWireSetup.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url

    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
