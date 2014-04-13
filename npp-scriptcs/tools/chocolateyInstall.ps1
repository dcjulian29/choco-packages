﻿$packageName = "npp-scriptcs"
$installerType = "msi"
$installerArgs = "/q /NORESTART"
$url = "https://csscriptnpp.codeplex.com/downloads/get/825517"
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
