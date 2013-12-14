$packageName = "npp-scriptcs" # arbitrary name for the package, used in messages
$installerType = "msi" #only one of these two: exe or msi
$installerArgs = "/q"
$url = "https://csscriptnpp.codeplex.com/downloads/get/766885"
$url64 = $url # 64bit URL here or just use the same as $url

try
{
    Install-ChocolateyPackage $packageName $installerType $installerArgs $url $url64

    Write-ChocolateySuccess $packageName
}
catch
{
    Write-ChocolateyFailure $packageName $($_.Exception.Message)
    throw
}
