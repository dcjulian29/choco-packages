$packageName = "firefox"
$installerType = "EXE"
$installerArgs = "-ms"
$url = "https://download.mozilla.org/?product=firefox-31.0-SSL&os=win&lang=en-US"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try {
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url

    Start-ChocolateyProcessAsAdmin "Remove-Item '$($env:PUBLIC)\Desktop\Mozilla Firefox.lnk' -Force"
    
    Write-ChocolateySuccess $packageName
} catch {
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
