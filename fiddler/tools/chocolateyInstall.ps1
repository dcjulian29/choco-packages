$packageName = "fiddler"
$installerType = "EXE"
$installerArgs = "/S"
$url = "http://www.telerik.com/docs/default-source/fiddler/fiddler4setup.exe?sfvrsn=2"

if ($psISE) {
    Import-Module -name "$env:ChocolateyInstall\chocolateyinstall\helpers\chocolateyInstaller.psm1"
}

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
