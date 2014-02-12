$packageName = "npp-scriptcs" # arbitrary name for the package, used in messages
$installerType = "msi" #only one of these two: exe or msi
$installerArgs = "/q /NORESTART"
$url = "https://csscriptnpp.codeplex.com/downloads/get/789212"
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
