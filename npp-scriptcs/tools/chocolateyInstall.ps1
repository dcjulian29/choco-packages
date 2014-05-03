$packageName = "npp-scriptcs"
$installerType = "msi"
$installerArgs = "/q /NORESTART"
$url = "http://csscriptnpp.codeplex.com/downloads/get/834618"
$validExitCodes = @(0,3010)

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url -validExitCodes $validExitCodes

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
