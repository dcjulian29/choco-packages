$packageName = "typescript"
$installerType = "EXE"
$installerArgs = "/Passive /NoRestart"
$url = "http://download.microsoft.com/download/2/F/F/2FFA1FBA-97CA-4FFB-8ED7-A4AE06398948/TypeScriptSetup.0.9.5.exe"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
    $ErrorActionPreference = "Stop"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
