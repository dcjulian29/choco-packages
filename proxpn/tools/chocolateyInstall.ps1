$packageName = "proxpn" # arbitrary name for the package, used in messages
$installerType = "exe" #only one of these two: exe or msi
$installerArgs = "/S"
$url = "https://proxpn.com/installproXPN.exe"
$url64 = $url

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
