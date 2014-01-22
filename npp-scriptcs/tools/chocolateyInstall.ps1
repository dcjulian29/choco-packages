$packageName = "npp-scriptcs" # arbitrary name for the package, used in messages
$installerType = "msi" #only one of these two: exe or msi
$installerArgs = "/q /NORESTART"
$url = "https://csscriptnpp.codeplex.com/downloads/get/781204"
$url64 = $url # 64bit URL here or just use the same as $url
$validExitCodes = @(0,3010)

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64 -validExitCodes $validExitCodes

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
