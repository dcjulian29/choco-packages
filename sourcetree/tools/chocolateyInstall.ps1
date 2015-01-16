$packageName = "sourcetree"
$installerType = "EXE"
$installerArgs = "/passive"
$url = "http://downloads.atlassian.com/software/sourcetree/windows/SourceTreeSetup_1.6.12.exe"

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
